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



  desc 'iteration', 'resolve nonlinear equation by the method of simple iterations'
  def iterate
    iterator = NonlinearSimpleIterator.new
    iterator.fi_function = Proc.new { |x| 5 * (Math.sin(x) ** 2 + 1) }
    iterator.eps = 0.001

    f = Proc.new { |x| x - 5 * (Math.sin(x) ** 2) - 5 }

    [3, 4, 6].each do |start_point|
      iterator.start_point = start_point
      solution = iterator.iterate
      puts solution.to_s.colorize(:red)
      puts f.call(solution).to_s.colorize(:blue)
    end
  end
end
