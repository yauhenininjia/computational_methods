class GaussianSolver

  def initialize(matrix, b)
    @matrix = matrix
    @b = b
  end

  def solve
    size = @matrix.row_size

    (0..(size - 1)).each do |column|
      p = column

      ((column + 1)..(size - 1)).each do |m|
        p = m if @matrix.row_vectors[p][column] < @matrix.row_vectors[m][column]
      end

      (column..size).each do |j|
        @matrix[column, j], @matrix[p, j] = @matrix[p, j], @matrix[column, j]
      end

      @b.swap_rows(column, p)

      ((column + 1)..(size - 1)).each do |m|
        w = @matrix[m, column].to_f / @matrix[column, column]

        (0..(size - 1)).each do |i|
          @b[m, i] -= w * @b[column, i]
        end

        (column..(size - 1)).each do |i|
          @matrix[m, i] -= w * @matrix[column, i]
        end

      end
    end

    (size - 1).downto(0) do |column|
      (0..(size - 1)).each { |k| @b[column, k] /= @matrix[column, column] }
      @matrix[column, column] = 1.0


      (column - 1).downto(0).each do |j|
        w = @matrix[j, column].to_f / @matrix[column, column]
        @matrix[j, column] -= w * @matrix[column, column]

        (0..(size - 1)).each do |m|
          @b[j, m] -= w * @b[column, m]
        end
      end
    end

    @b
  end

end
