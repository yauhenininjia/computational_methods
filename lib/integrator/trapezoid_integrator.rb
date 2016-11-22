class TrapezoidIntegrator < Integrator
  def initialize(a:, b:, partitions_count:)
    @a, @b, @partitions_count = a, b, partitions_count
    @step = (b - a).to_f / partitions_count
  end

  def integrate
    sum = arguments.inject(0) { |sum, arg| sum + @function.call(arg) }
    @step * ( ((@function.call(@a) + @function.call(@b)).to_f / 2) + sum )
  end

  private

  def arguments
    ((@a + @step)..(@b - @step)).step(@step).to_a
  end
end
