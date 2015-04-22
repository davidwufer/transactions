# For debugging
require 'pry'

require './parser'
require './transaction_data'
require './graph'

module Transaction
  class Calculator
    require 'set'

    attr_reader :filepath

    def initialize(args={})
      @filepath = args[:filepath]
    end

    def results
      parser = Parser.new(filepath: filepath)
      graph = Graph.new(transaction_data: parser.data)

      # Algorithm time!
      # Else for the remaining edges, create indirect edges through edge #1
      # Move onto the next node, making sure not to look at the nodes already looked at
      # When all nodes have been looked at, then you're done!

      visited_nodes = Set.new()
      graph.nodes.each do |node|
        relevant_connected_nodes = graph.connected_nodes(node).reject {|node| visited_nodes.include?(node)}

        # If < 1 edges, then move on
        continue unless relevant_connected_nodes.size > 1

        # I don't know what to call this, but redirect all edges through this one
        intermediate_node = relevant_connected_nodes.pop
        relevant_connected_nodes.each do |relevant_connected_node|
          amount = graph.remove_edge(node, relevant_connected_node)

          graph.add_edge(node, intermediate_node, amount)
          graph.add_edge(intermediate_node, relevant_connected_node, amount)
        end

        visited_nodes << node
      end

    end
  end
end
