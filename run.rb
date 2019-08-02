require './input_scanner.rb'
require './output_processor.rb'

scanner = InputScanner.new(ARGV[0])

scanner.process_input

puts OutputProcessor.output