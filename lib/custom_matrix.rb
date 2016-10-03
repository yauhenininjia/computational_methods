module CustomMatrix
  
  def custom_pretty_print
    string = ''
    maxes = array_maxes
    row_vectors.each do |row|
      row.each_with_index do |value, index|
        string.concat " #{value.to_s.rjust(maxes[index])}"
      end
      string.concat("\n")
    end
    string
  end

  def custom_inverse
    begin
      determinant = custom_determinant
      raise ExceptionForMatrix::ErrNotRegular, 'Determinant is equal to 0' if determinant == 0
      (1.0 / determinant) * custom_adjoint.transpose
    rescue ExceptionForMatrix::ErrNotRegular => e
      puts e.message
    end
  end

  def custom_adjoint
    Matrix.build(row_vectors.count, column_vectors.count) do |row, column|
      cofactor = custom_determinant(custom_additional_minor(row, column))
      ((-1) ** (row + column)) * cofactor
    end
  end

  def custom_transpose
    Matrix.build(column_vectors.count, row_vectors.count) { |row, column| row_vectors[column][row] }
  end

  def custom_determinant(matrix = self)
    return matrix.first if matrix.count == 1 && matrix.first.is_a?(Numeric)
    result = 0
    matrix.row_vectors.first.each_with_index do |value, index|
      cofactor = custom_determinant(matrix.custom_additional_minor(0, index))
      result += ((-1) ** index) * value * cofactor
    end
    result
  end

  def custom_additional_minor(row_to_remove, column_to_remove)
    with_removed_row = row_vectors.map do |row|
      row_vectors.to_a.index(row) == row_to_remove ? nil : row
    end.compact

    with_removed_column = with_removed_row.map do |row|
      row.map.with_index do |value, column_index|
        column_index == column_to_remove ? nil : value
      end.to_a.compact
    end

    minor = with_removed_column

    Matrix.build(row_vectors.count - 1, column_vectors.count - 1) do |row, column|
      minor[row][column]
    end
  end

  def swap_rows(first_row, second_row)
    @rows[first_row], @rows[second_row] = @rows[second_row], @rows[first_row]
  end


  private

  def array_maxes
    row_vectors.reduce([]) do |maxes, row|
      row.each_with_index do |value, index|
        maxes[index] = [(maxes[index] || 0), value.to_s.length].max
      end
      maxes
    end
  end
end
