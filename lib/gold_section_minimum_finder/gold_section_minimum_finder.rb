class GoldSectionMinimumFinder
  attr_writer :start, :end, :function, :default_params_for_function
  attr_accessor :epsilon

  GOLDEN_SECTION_RATE = 0.382

  def initialize
    @default_params_for_function = []
  end

  def find_minimum
    @default_params_for_function = [nil, 10]
    first_min_arg, first_min_value = find

    @default_params_for_function = [first_min_arg, nil]
    second_min_arg, second_min_value = find

    last_first_min_arg = nil
    last_second_min_arg = nil

    while ( @function.call([first_min_arg, second_min_arg]) -
            @function.call([last_first_min_arg || 10, last_second_min_arg || -10])
          ).abs > @epsilon
      last_first_min_arg = first_min_arg
      last_second_min_arg = second_min_arg

      @default_params_for_function = [nil, last_second_min_arg]
      first_min_arg, first_min_value = find

      @default_params_for_function = [first_min_arg, nil]
      second_min_arg, second_min_value = find
    end

    [first_min_arg, second_min_arg]
  end

  def find
    start = @start
    finish = @end

    first_golden_point = start + GOLDEN_SECTION_RATE * (finish - start)
    second_golden_point = finish - GOLDEN_SECTION_RATE * (finish - start)
    first_result = @function.call(params_for_function(first_golden_point))
    second_result = @function.call(params_for_function(second_golden_point))

    while (finish - start).abs > @epsilon
      if first_result > second_result
        start = first_golden_point
        first_golden_point = second_golden_point
        first_result = second_result
        second_golden_point = finish - GOLDEN_SECTION_RATE * (finish - start)
        second_result = @function.call(params_for_function(second_golden_point))
      else
        finish = second_golden_point
        second_golden_point = first_golden_point
        second_result = first_result
        first_golden_point = start + GOLDEN_SECTION_RATE * (finish - start)
        first_result = @function.call(params_for_function(first_golden_point))
      end
    end

    min_arg = (start + finish) / 2.0
    min_value = @function.call(params_for_function(min_arg))
    [min_arg, min_value]
  end

  private

  def params_for_function(param)
    @default_params_for_function.map { |default_param| default_param.nil? ? param : default_param }
  end
end