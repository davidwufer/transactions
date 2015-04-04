require './parser'
require './transaction_data'

module Transaction
  class Graph
  end

  class Runner
    attr_reader :filepath

    def initialize(args={})
      @filepath = args[:filepath]
    end

    def results
      parser = Parser.new(filepath)
      data = parser.data
    end
  end
end

filepath = ARGV[0]
runner = Transaction::Runner.new(filepath: filepath)
puts runner.results
