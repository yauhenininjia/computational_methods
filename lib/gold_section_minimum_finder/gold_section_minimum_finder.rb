class GoldSectionMinimumFinder
  attr_writer :function, :start_point, :epsilon, :step

  GOLDEN_SECTION_RATE = 0.382

  def find_minimum
    point = minimize_point(@start_point)

    last_point = nil
    while (@function.call(point) - @function.call(last_point || @start_point)).abs > @epsilon do
      last_point = point
      point = minimize_point(point)
    end
    point
  end

  def find(function, start, finish)
    first_golden_point = start + GOLDEN_SECTION_RATE * (finish - start)
    second_golden_point = finish - GOLDEN_SECTION_RATE * (finish - start)
    first_result = function.call(first_golden_point)
    second_result = function.call(second_golden_point)

    while (finish - start).abs > @epsilon
      if first_result > second_result
        start = first_golden_point
        first_golden_point = second_golden_point
        first_result = second_result
        second_golden_point = finish - GOLDEN_SECTION_RATE * (finish - start)
        second_result = function.call(second_golden_point)
      else
        finish = second_golden_point
        second_golden_point = first_golden_point
        second_result = first_result
        first_golden_point = start + GOLDEN_SECTION_RATE * (finish - start)
        first_result = function.call(first_golden_point)
      end
    end

    min_arg = (start + finish) / 2.0
    min_value = function.call(min_arg)
    [min_arg, min_value]
  end

  def get_direction(function, arg)
    function.call(arg) > function.call(arg + @epsilon) ? 1 : -1
  end

  def get_fork(function, arg, direction)
    i = 0
    loop do
      break if !(
        function.call(arg + direction * (i + 0) * @step) > function.call(arg + direction * (i + 1) * @step) &&
        function.call(arg + direction * (i + 1) * @step) > function.call(arg + direction * (i + 2) * @step)
      )
      i += 1
    end

    [
      arg + direction * (i + 0) * @step,
      arg + direction * (i + 1) * @step,
      arg + direction * (i + 2) * @step
    ]
  end

  def fixed_arg(point, coordinate, index)
    point.map.with_index { |coord, ind| ind == index ? coordinate : coord }
  end

  def minimize_point(input_point)
    point = input_point
    input_point.each_with_index do |coordinate, index|
      function = Proc.new { |x| @function.call(fixed_arg(point, x, index)) }
      direction = get_direction(function, coordinate)
      start, mid, finish = get_fork(function, coordinate, direction)
      min_arg, min_value = find(function, *[start, finish].sort)
      point = fixed_arg(point, min_arg, index)
    end
    point
  end
end
