class Integrator
  attr_writer :function

  def initialize(method, a:, b:, partitions_count:)
    @method = method
    @a = a
    @b = b
    @partitions_count = partitions_count
  end

  def get_integrator
    case @method
    when 'trapezoids' then TrapezoidIntegrator.new(a: @a, b: @b, partitions_count: @partitions_count)
    end
  end
end