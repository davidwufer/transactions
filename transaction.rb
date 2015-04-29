# For debugging
require 'pry'

require './parser'
require './transaction_data'
require './graph'

module Transaction
  class Runner
    def initialize(args={})
      filepath = args[:filepath]
      parser = Parser.new(filepath: filepath)
      graph = Graph.new(transaction_data: parser.data)

      @calculator = Calculator.new(graph: graph)
    end
  end


  class Calculator
    require 'set'

    attr_reader :graph

    def initialize(args={})
      @graph = args[:graph]
    end

    def results
      # Algorithm:
      # For each node, look at all its connected, unvisited nodes
      # If the number of these nodes is <= 1, then continue
      # Else choose one connected, invisited node as an intermediate node
      # and redirect all other edges through this node by the following:
      #  A: Current Node
      #  B: Intermediate Node (also connected to A)
      #  C: Node connected to A with amount X
      #  Create/Add to an edge between A and B using value X
      #  Create/Add to an edge between B and C using value X

      visited_nodes = Set.new()
      # graph.nodes.keys should really be abstracted
      graph.nodes.keys.each do |node|
        relevant_connected_nodes = graph.connected_nodes(node).reject {|node| visited_nodes.include?(node)}

        next unless relevant_connected_nodes.size > 1

        intermediate_node = relevant_connected_nodes.pop
        relevant_connected_nodes.each do |relevant_connected_node|
          amount = graph.remove_edge(node, relevant_connected_node)

          graph.add_edge(node, intermediate_node, amount)
          graph.add_edge(intermediate_node, relevant_connected_node, amount)
        end

        visited_nodes << node
      end

      graph
    end
  end
end
