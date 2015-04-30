# For debugging
require 'pry'

require './parser'
require './transaction_data'
require './graph'

module Transaction
  class Runner
    attr_reader :calculator

    def initialize(args={})
      filepath = args[:filepath]
      parser = Parser.new(filepath: filepath)
      graph = Graph.new(transaction_data: parser.data)

      @calculator = Calculator.new(graph: graph)
    end

    def results
      calculator.results
    end
  end

  class CalculatorResults
    extend Forwardable
    attr_reader :graph
    def_delegators :graph, :owed_amount

    def initialize(args={})
      @graph = args[:graph]
    end

    def to_s
      data.each_pair do |ower, owed_people_data|
        owed_people_data.each_pair do |owed, amount|
          puts "#{ower} -> #{owed} : $#{amount.round(2)}"
        end
        puts
      end
    end

    def data
      filtered_data = {}
      graph.nodes.each_pair do |ower, owed_people_data|
        filtered_owed_people_data = owed_people_data.select {|owed, amount| amount > 0}
        if filtered_owed_people_data.size > 0
          filtered_data[ower] = filtered_owed_people_data
        end
      end
      filtered_data
    end
  end

  class Calculator
    require 'set'

    attr_reader :graph

    def initialize(args={})
      @graph = args[:graph]
    end

    def results
      CalculatorResults.new(graph: calculate_graph)
    end

    private
      def calculate_graph
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
        sorted_nodes = graph.nodes.keys.sort {|first, second| graph.outgoing_nodes(first) <=> graph.outgoing_nodes(second)}
        sorted_nodes.each do |node|
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
