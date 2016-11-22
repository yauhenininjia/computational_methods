class Differentiator
  # attr_writer :first_order_differential_function
  # attr_writer :second_order_differential_function
  attr_accessor :differential_functions

  def initialize(a:, b:, epsilon:)
    @a, @b, @epsilon = a, b, epsilon
    @differential_functions = []
  end

  def do_stuff
    @differential_functions.each do |function|
      puts 'Differential'
      compare_function_values(function)
    end
  end

  private

  def compare_function_values(function)
    control_points.each do |point|
      approximated = approximated_value(function, point)
      exact = exact_value(function, point)
      diff = (approximated - exact).abs
      puts [approximated, exact, diff].join(' ')
    end
  end

  def control_points
    (0..10).map { |j| @a + j * (@b - @a) / 10.0 }
  end

  def exact_value(function, arg)
    function.call(arg)
  end

  def approximated_value(function, arg)
    (function.call(arg + @epsilon) + function.call(arg - @epsilon)) / 2.0
  end

end
