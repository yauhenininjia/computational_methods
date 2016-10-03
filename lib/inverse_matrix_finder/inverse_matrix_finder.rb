class InverseMatrixFinder
  attr_reader :matrix

  def initialize(file)
    @file = file
    input = CSV.read(@file)
    @matrix = Matrix.build(input.count, input.first.count) { |row, col| input[row][col].to_i }
  end

  def find(method)
    puts 'Input'
    puts @matrix.custom_pretty_print

    case method
    when 'adjoint' then find_adjoint
    when 'gaussian' then find_gaussian
    end
  end

  private

  def find_adjoint
    begin
      @matrix.custom_inverse
    rescue ExceptionForMatrix::ErrDimensionMismatch => e
      puts e.message
    end
  end

  # SHIT BELOW
  def find_gaussian
    size = @matrix.row_size
    b = Matrix.identity(size)
    GaussianSolver.new(@matrix, b).solve
  end
end

