require './transaction'

filepath = ARGV.length == 1 ? ARGV[0] : "data/master.txt"
calculator = Transaction::Calculator.new(filepath: filepath)
puts calculator.results
