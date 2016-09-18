require './lib/computational_methods'

class App < Thor
  desc 'inverse matrix', 'find inverse matrix'
  method_option :file, desc: 'file with input data', default: 'input.csv', aliases: '-f'
  method_option :method, desc: 'method of computation', default: 'gaussian', aliases: '-m'
  def inverse_matrix
    finder = InverseMatrixFinder.new(options[:file])
    result = finder.find(options[:method])
    puts "Inverse Matrix:\n#{result.custom_pretty_print}" unless result.nil?
  end  
end
