# For debugging
require 'pry'

require './parser'
require './transaction_data'

module Transaction
  class Graph
    attr_reader :transaction_data

    def initialize(args={})
      @transaction_data = args[:transaction_data] || []
      initialize_nodes
    end

    private
      def initialize_nodes
        transaction_data.each do |transaction_datum|
        end
      end
  end

  class Runner
    attr_reader :filepath

    def initialize(args={})
      @filepath = args[:filepath]
    end

    def results
      parser = Parser.new(filepath: filepath)
      graph = Graph.new(transaction_data: parser.data)
    end
  end
end
