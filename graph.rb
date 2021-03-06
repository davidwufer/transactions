module Transaction
  class Graph
    attr_reader :nodes

    def initialize(args={})
      @nodes = {}

      transaction_data = args[:transaction_data] || []
      initialize_nodes(transaction_data)
    end

    def add_node(node)
      nodes[node] = Hash.new(0) unless nodes.has_key?(node)
      self
    end

    def outgoing_nodes(node)
      nodes[node].values.select {|val| val > 0}.length
    end

    def connected_nodes(node)
      nodes[node].keys
    end

    def add_edge(ower, owed, amount)
      nodes[ower][owed] += amount
      nodes[owed][ower] -= amount

      if nodes[ower][owed].zero?
        remove_edge(ower, owed)
      end
      self
    end

    def remove_edge(owed, ower)
      nodes[ower].delete(owed)
      nodes[owed].delete(ower)
    end

    def has_edge?(ower, owed)
      nodes[ower].has_key?(owed)
    end

    def owed_amount(ower, owed)
      nodes.has_key?(ower) ? nodes[ower][owed] : 0
    end

    private
      def initialize_nodes(transaction_data)
        transaction_data.each do |datum|
          add_node(datum.ower)
          add_node(datum.owed)
          add_edge(datum.ower, datum.owed, datum.amount)
        end
      end
  end
end
