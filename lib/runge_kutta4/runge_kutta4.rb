# For system of 2 functions only
class RungeKutta4
  attr_accessor :p_func, :g_func, :h, :x, :y, :z

  def initialize(x, y, z)
    @x, @y, @z = x, y, z
  end

  def next_y
    @y + (k_1_1 + 2 * k_2_1 + 2 * k_3_1 + k_4_1) / 6.0
  end

  def next_z
    @z + (k_1_2 + 2 * k_2_2 + 2 * k_3_2 + k_4_2) / 6.0
  end

  private

  def k_1_1
    @h * @p_func.call(@x, @y, @z)
  end

  def k_1_2
    @h * @g_func.call(@x, @y, @z)
  end

  def k_2_1
    @h * @p_func.call(@x + @h / 2.0, @y + k_1_1 / 2.0, @z + k_1_2 / 2.0)
  end

  def k_2_2
    @h * @g_func.call(@x + @h / 2.0, @y + k_1_1 / 2.0, @z + k_1_2 / 2.0)
  end

  def k_3_1
    @h * @p_func.call(@x + @h / 2.0, @y + k_2_1 / 2.0, @z + k_2_2 / 2.0)
  end

  def k_3_2
    @h * @g_func.call(@x + @h / 2.0, @y + k_2_1 / 2.0, @z + k_2_2 / 2.0)
  end

  def k_4_1
    @h * @p_func.call(@x + @h, @y + k_3_1, @z + k_3_2)
  end

  def k_4_2
    @h * @g_func.call(@x + @h, @y + k_3_1, @z + k_3_2)
  end
end
