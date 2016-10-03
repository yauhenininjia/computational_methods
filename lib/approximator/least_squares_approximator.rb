class LeastSquaresApproximator < Approximator

  def initialize(a:, b:, m:, n:)
    @a, @b, @m, @n = a, b, m, n
  end

  def approximate(arg)
    c_coefficients_matrix.each.with_index.inject(0) do |sum, (element, index)|
      sum + element * legendre_polynomial(index + 1).call(arg)
    end
  end

  private

  def legendre_arg(arg)
    (arg - (@b + @a) / 2.0) * (2.0 / (@b - @a))
  end

  def legendre_polynomial(index)
    case index
    when 1 then Proc.new { |arg| 1 }
    when 2 then Proc.new { |arg| arg }
    else Proc.new { |arg| (2 * (index - 1) + 1) * arg * legendre_polynomial(index - 1).call(arg) - (index - 1) * legendre_polynomial(index - 2).call(arg) }
    end
  end

  def build_b_matrix
    Matrix.build(@n, @n) do |row, column|
      sum = 0

      (1..@m).each do |j|
        point = initial_table_function.call(@a, @b, @m, j)
        sum += init_table[point] * legendre_polynomial(row + 1).call(point)
      end

      column == 0 ? sum : 0
    end
  end

  def build_g_matrix
    Matrix.build(@n, @n) do |row, column|
      sum = 0

      (1..@m).each do |j|
        point = initial_table_function.call(@a, @b, @m, j)
        sum += legendre_polynomial(row + 1).call(point) * legendre_polynomial(column + 1).call(point)
      end

      sum
    end
  end

  def c_coefficients_matrix
    return @c unless @c.nil?
    solution = GaussianSolver.new(build_g_matrix, build_b_matrix).solve
    # HACK solution contains zero columns
    @c = Matrix.build(solution.row_size, 1) do |row, column|
      solution.row_vectors[row][column]
    end
  end
end
