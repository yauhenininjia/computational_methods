class GoldSectionMinimumFinder
  attr_writer :epsilon, :start, :end, :function, :default_params_for_function

  GOLDEN_SECTION_RATE = 0.382

  def initialize
    @default_params_for_function = []
  end

  def find
    first_golden_point = @start + GOLDEN_SECTION_RATE * (@end - @start)
    second_golden_point = @end - GOLDEN_SECTION_RATE * (@end - @start)
    first_result = @function.call(params_for_function(first_golden_point))
    second_result = @function.call(params_for_function(second_golden_point))

    while (@end - @start).abs > @epsilon
      if first_result > second_result
        @start = first_golden_point
        first_golden_point = second_golden_point
        first_result = second_result
        second_golden_point = @end - GOLDEN_SECTION_RATE * (@end - @start)
        second_result = @function.call(params_for_function(second_golden_point))
      else
        @end = second_golden_point
        second_golden_point = first_golden_point
        second_result = first_result
        first_golden_point = @start + GOLDEN_SECTION_RATE * (@end - @start)
        first_result = @function.call(params_for_function(first_golden_point))
      end
    end

    min_arg = (@start + @end) / 2.0
    min_value = @function.call(params_for_function(min_arg))
    [min_arg, min_value]
  end

  private

  def params_for_function(param)
    @default_params_for_function.map { |default_param| default_param.nil? ? param : default_param }
  end
end