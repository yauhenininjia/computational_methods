class Adams3
  attr_writer :x_values, :y_values, :z_values, :step, :p_func, :g_func, :upper_bound

  def values
    enum = (@x_values.last + @step)..@upper_bound
    enum.step(@step).each_with_index do |x, index|

      y_delta_f_1, y_delta_f_2, y_delta_f_3 = newton_polynom_values(@p_func, index)

      next_y =  @y_values[index + 3] +
                @step * @p_func.call(@x_values[index + 3], @y_values[index + 3], @z_values[index + 3]) +
                ((@step ** 2) / 2.0) * y_delta_f_1 +
                ((@step ** 3) / 12.0) * y_delta_f_2 +
                ((@step ** 4) / 8.0) * y_delta_f_3

      z_delta_f_1, z_delta_f_2, z_delta_f_3 = newton_polynom_values(@g_func, index)

      next_z =  @z_values[index + 3] +
                @step * @g_func.call(@x_values[index + 3], @y_values[index + 3], @z_values[index + 3]) +
                ((@step ** 2) / 2.0) * z_delta_f_1 +
                ((@step ** 3) / 12.0) * z_delta_f_2 +
                ((@step ** 4) / 8.0) * z_delta_f_3

      @x_values << x
      @y_values << next_y
      @z_values << next_z
    end

    [@x_values, @y_values, @z_values]
  end

  private

  def newton_polynom_values(function, index)
    delta_f_1 = function.call(@x_values[index + 3], @y_values[index + 3], @z_values[index + 3]) -
                function.call(@x_values[index + 2], @y_values[index + 2], @z_values[index + 2])

    delta_f_2 = function.call(@x_values[index + 3], @y_values[index + 3], @z_values[index + 3]) -
                2 * function.call(@x_values[index + 2], @y_values[index + 2], @z_values[index + 2]) +
                function.call(@x_values[index + 1], @y_values[index + 1], @z_values[index + 1])

    delta_f_3 = function.call(@x_values[index + 3], @y_values[index + 3], @z_values[index + 3]) -
                3 * function.call(@x_values[index + 2], @y_values[index + 2], @z_values[index + 2]) +
                3 * function.call(@x_values[index + 1], @y_values[index + 1], @z_values[index + 1]) -
                function.call(@x_values[index], @y_values[index], @z_values[index])

    [delta_f_1, delta_f_2, delta_f_3]
  end
end
