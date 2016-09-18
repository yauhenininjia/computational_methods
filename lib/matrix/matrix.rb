class Matrix
  include CustomMatrix

  def []=(i, j, x)
    @rows[i][j] = x
  end
end
