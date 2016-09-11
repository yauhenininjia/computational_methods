class InverseMatrixFinder
  def initialize(file)
    @file = file
    input = CSV.read(@file)
    @matrix = Matrix.build(input.count, input.first.count) { |row, col| input[row][col].to_i }
  end

  def find
    begin
      puts 'Input'
      puts @matrix.custom_pretty_print
      @matrix.custom_inverse
    rescue ExceptionForMatrix::ErrDimensionMismatch => e
      puts e.message
    end
  end
end

