require './lib/computational_methods'

class App < Thor
  desc 'inverse matrix', 'find inverse matrix'
  method_option :file, desc: 'file with input data', default: 'input.csv', aliases: '-f'
  def inverse_matrix
    result = InverseMatrixFinder.new(options[:file]).find
    puts "Inverse Matrix:\n#{result.custom_pretty_print}" unless result.nil?
  end  
end
