require './transaction'

filepath = ARGV.length == 1 ? ARGV[0] : "data/master.txt"
runner = Transaction::Runner.new(filepath: filepath)
puts runner.results
