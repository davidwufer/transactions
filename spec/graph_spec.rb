require './transaction'

include Transaction

describe Graph do
  let(:td) { TransactionData.new(ower: "David", owed: "Angela", amount: 200) }
  let(:graph) { Graph.new(transaction_data: [td]) }

  describe "TransactionData reading" do
    it "converts a transaction data into nodes" do
      expect(graph.nodes).to include("David", "Angela")
    end

    it "adds the right amount to ower lookup" do
      expect(graph.owed_amount("David", "Angela")).to eq(200)
    end

    it "adds the right amount to owed lookup" do
      expect(graph.owed_amount("Angela", "David")).to eq(-200)
    end

    it "returns the right amount for nonexistent owers" do
      expect(graph.owed_amount("Peter", "Angela")).to eq(0)
    end

    it "returns the right amount for nonexistent owed people" do
      expect(graph.owed_amount("David", "Janet")).to eq(0)
    end

    it "returns the right connected node" do
      expect(graph.connected_nodes("David")).to eq(["Angela"])
    end

    it "returns the right number of outgoing nodes when one exists" do
      expect(graph.outgoing_nodes("David")).to eq(1)
    end

    it "returns the right number of outgoing nodes when one does not exist" do
      expect(graph.outgoing_nodes("Angela")).to eq(0)
    end
  end

  describe "Graph modification" do
    describe "#add_edge" do
      before(:each) do
        graph.add_node("Baran")
        graph.add_edge("David", "Baran", 200)
      end

      it "adds a new edge with the right amount" do
        expect(graph.owed_amount("David", "Baran")).to eq(200)
        expect(graph.owed_amount("Baran", "David")).to eq(-200)
      end

      it "adds it to the connected nodes" do
        expect(graph.connected_nodes("David").sort).to eq(["Angela", "Baran"].sort)
      end
    end

    it "adds to an existing edge with the right amount" do
      graph.add_edge("David", "Angela", 200)
      expect(graph.owed_amount("David", "Angela")).to eq(400)
    end

    it "adds to an existing reversed edge with the right amount" do
      graph.add_edge("Angela", "David", 200)
      expect(graph.owed_amount("David", "Angela")).to eq(0)
    end

    it "removes an edge if the amount reaches 0" do
      graph.add_edge("Angela", "David", 200)
      expect(graph.has_edge?("David", "Angela")).to be false
      expect(graph.has_edge?("Angela", "David")).to be false
    end

    it "reverses an edge if the amount added exceeds the negative of the amount already there" do
      graph.add_edge("Angela", "David", 400)
      expect(graph.owed_amount("David", "Angela")).to eq(-200)
      expect(graph.owed_amount("Angela", "David")).to eq(200)
    end

    describe "#remove_edge" do
      it "removes an edge" do
        graph.remove_edge("David", "Angela")
        expect(graph.has_edge?("David", "Angela")).to be false
        expect(graph.owed_amount("David", "Angela")).to eq 0
      end

      it "removes a negative edge" do
        graph.remove_edge("Angela", "David")
        expect(graph.has_edge?("David", "Angela")).to be false
        expect(graph.owed_amount("David", "Angela")).to be 0
      end

      it "returns the owed amount" do
        expect(graph.remove_edge("David", "Angela")).to eq(200)
      end

      it "returns the owed amount for a negative edge" do
        expect(graph.remove_edge("Angela", "David")).to eq(-200)
      end
    end
  end
end
