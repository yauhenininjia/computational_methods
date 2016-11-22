class NonlinearSimpleIterator
  attr_writer :fi_function, :start_point, :eps, :f

  def iterate
    current_x = @start_point
    next_x = @fi_function.call(current_x)
    while (current_x - next_x).abs > @eps
      current_x = next_x
      next_x = @fi_function.call(current_x)
    end

    current_x
  end
end
