class Approximator
  attr_accessor :function, :initial_table_function, :control_function

  def initialize(method, a:, b:, m:, n:)
    @method = method
    @a, @b, @m, @n = a, b, m, n
  end

  def get_approximator
    case @method
    when 'least_squares' then LeastSquaresApproximator.new(a: @a, b: @b, m: @m, n: @n)
    end
  end

  def init_table
    return @initial_table unless @initial_table.nil?
    @initial_table = {}

    (1..@m).each do |i|
      point = initial_table_function.call(@a, @b, @m, i)
      @initial_table[point] = function.call(point)
    end

    @initial_table
  end

  def control_points
    (0..20).map { |i| control_function.call(@a, @b, i) }
  end

end
