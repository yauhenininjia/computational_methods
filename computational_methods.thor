require './lib/computational_methods'

class App < Thor
  desc 'inverse matrix', 'find inverse matrix'
  method_option :file, desc: 'file with input data', default: 'input.csv', aliases: '-f'
  method_option :method, desc: 'method of computation', default: 'gaussian', aliases: '-m'
  def inverse_matrix
    finder = InverseMatrixFinder.new(options[:file])
    result = finder.find(options[:method])
    puts "Inverse Matrix:\n#{result.custom_pretty_print}" unless result.nil?
  end

  desc 'approximation', 'approximate value of the function'
  method_option :method, desc: 'method of approximation', default: 'least_squares', aliases: '-m'
  def approximate
    approximator = Approximator.new(options[:method], a: 1.0, b: 4.0, m: 11.0, n: 4.0).get_approximator
    approximator.function = Proc.new { |arg| arg - 5 * (Math.sin(arg) ** 2) }
    approximator.initial_table_function = Proc.new { |a, b, m, i| a + (i - 1) * (b - a) / (m - 1) }
    approximator.control_function = Proc.new { |a, b, i| a + i * ((b - a) / 20.0) }

    approximator.control_points.each do |point|
      function_value = approximator.function.call(point)
      approximation_value = approximator.approximate(point)
      error = function_value - approximation_value

      puts "Function(#{point})      = #{function_value}"
      puts "Approximation(#{point}) = #{approximation_value}"
      puts "Error              = #{error}"
      puts
    end
  end

  desc 'intagration', 'find integral of function'
  method_option :method, desc: 'method of integration', default: 'trapezoids', aliases: '-m'
  def integrate
    integrator = Integrator.new(options[:method], a: 1, b: 4, partitions_count: 1_000).get_integrator
    integrator.function = Proc.new { |arg| arg - 5 * (Math.sin(arg) ** 2) }
    puts integrator.integrate
  end

  desc 'differentiation', 'find 1st and 2nd differential of function'
  def differentiate
    differentiator = Differentiator.new(a: 1, b:4, epsilon: 0.001)
    differentiator.differential_functions << Proc.new { |arg| 1 - 10 * Math.sin(arg) * Math.cos(arg) }
    differentiator.differential_functions << Proc.new { |arg| -10 * (Math.sin(arg) ** 2) + 10 * (Math.cos(arg) ** 2) }
    differentiator.do_stuff
  end

  desc 'eigen', 'find eigenvalues and eigenvector'
  method_option :file, desc: 'file with input data', default: 'input.csv', aliases: '-f'
  def eigen
    input = CSV.read(options[:file])
    matrix = Matrix.build(input.count, input.first.count) { |row, col| input[row][col].to_i }
    eigen_value_finder = Matrix::EigenvalueDecomposition.new(matrix)
    puts 'Eigen values:'
    puts eigen_value_finder.eigenvalues
    puts 'Eigen vectors:'
    puts eigen_value_finder.eigenvector_matrix_inv.custom_pretty_print
  end

  desc 'iteration', 'resolve nonlinear equation by the method of simple iterations'
  def iterate
    iterator = NonlinearSimpleIterator.new
    iterator.fi_function = Proc.new { |x| 5 * (Math.sin(x) ** 2 + 1) }
    iterator.eps = 0.001

    iterator.f = Proc.new { |x| x - 5 * (Math.sin(x) ** 2) - 5 }

    [3, 6, 9].each do |start_point|
      iterator.start_point =  start_point
      solution = iterator.iterate
      puts solution.to_s.colorize(:red)
    end
  end

  desc 'ode', 'solve system of ordinary differential equations'
  def ordinary_differential_equations
    initial_x = 1
    initial_y = 2 * initial_x
    initial_z = Math::E ** initial_x
    step = 0.05
    p_func = Proc.new { |x, y, z| y / (2 * x) + z / (Math::E ** x) }
    g_func = Proc.new { |x, y, z| y * z / (2 * x) }

    adams = Adams3.new
    adams.p_func = p_func
    adams.g_func = g_func
    adams.step = step
    adams.upper_bound = 3

    runge_kutta = RungeKutta4.new(initial_x, initial_y, initial_z)
    runge_kutta.p_func = p_func
    runge_kutta.g_func = g_func
    runge_kutta.h = step

    x_values = [initial_x]
    y_values = [initial_y]
    z_values = [initial_z]

    (initial_x + step..(initial_x + 3 * step)).step(step).each do |x|
      runge_kutta.x = x
      runge_kutta.y = y_values.last
      runge_kutta.z = z_values.last

      x_values << x
      y_values << runge_kutta.next_y
      z_values << runge_kutta.next_z
    end

    adams.x_values = x_values
    adams.y_values = y_values
    adams.z_values = z_values

    x_values, y_values, z_values = adams.values

    puts '2x'
    x_values.map.with_index do |x, index|
      x_string = x.to_s.colorize(:red)
      y_string = y_values[index].to_s.colorize(:green)
      value_string = (2 * x).to_s.colorize(:blue)
      puts [x_string, value_string, y_string].join(' ')
    end

    puts 'e^x'
    x_values.map.with_index do |x, index|
      x_string = x.to_s.colorize(:red)
      z_string = z_values[index].to_s.colorize(:green)
      value_string = (Math::E ** x).to_s.colorize(:blue)
      puts [x_string, value_string, z_string].join(' ')
    end
  end

  desc 'golden section', 'find minimum of function with gold section method'
  def gold_section
    rosenbrock_function = Proc.new { |args| 100 * ((args[1] + args[0] ** 2) ** 2) + (1 - args[0]) ** 2 }

    finder = GoldSectionMinimumFinder.new
    finder.function = rosenbrock_function
    finder.epsilon = 0.000_000_001
    finder.start = -3
    finder.end = 3

    first_min_arg, second_min_arg = finder.find_minimum
    puts [first_min_arg, second_min_arg].join(' ')
    puts rosenbrock_function.call([first_min_arg, second_min_arg])
  end

  desc 'penalty function method', 'find conditional minimum of function with peanlty function method'
  def penalty_function
    rosenbrock_function = Proc.new { |args| 100 * ((args[1] + args[0] ** 2) ** 2) + (1 - args[0]) ** 2 }
    fi_function = Proc.new { |args| [2 - args[0], 0].max }
    function = Proc.new do |args|
      fi_result = fi_function.call(args)
      fi_param = fi_result == 0 ? 0 : 1_000_000_000
      rosenbrock_function.call(args) + fi_param
    end

    finder = GoldSectionMinimumFinder.new
    finder.function = function
    finder.epsilon = 0.000_001
    finder.start = -5
    finder.end = 5

    first_min_arg, second_min_arg = finder.find_minimum

    puts [first_min_arg, second_min_arg].join(' ')
    puts rosenbrock_function.call([first_min_arg, second_min_arg])
  end
end
