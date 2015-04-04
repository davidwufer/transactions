require './transaction'

include Transaction

describe Graph do
  let(:td) { TransactionData.new(ower: "David", owed: "Angela", amount: 200) }
  let(:graph) { Graph.new(transaction_data: [td]) }

  describe "TransactionData reading" do
    it "converts a transaction data into nodes" do
      graph.nodes.should include("David", "Angela")
    end

    it "adds the right amount to ower lookup" do
      graph.owed_amount("David", "Angela").should == 200
    end

    it "adds the right amount to owed lookup" do
      graph.owed_amount("Angela", "David").should == -200
    end

    it "returns the right amount for nonexistent owers" do
      graph.owed_amount("Peter", "Angela").should == 0
    end

    it "returns the right amount for nonexistent owed people" do
      graph.owed_amount("David", "Janet").should == 0
    end
  end

  describe "Graph modification" do
    it "adds a new edge with the right amount" do
      graph.add_edge("David", "Baran", 200)
      graph.owed_amount("David", "Baran").should == 200
      graph.owed_amount("Baran", "David").should == -200
    end

    it "adds to an existing edge with the right amount" do
      graph.add_edge("David", "Angela", 200)
      graph.owed_amount("David", "Angela").should == 400
    end

    it "adds to an existing reversed edge with the right amount" do
      graph.add_edge("Angela", "David", 200)
      graph.owed_amount("David", "Angela").should == 0
    end

    it "removes an edge if the amount reaches 0" do
      graph.add_edge("Angela", "David", 200)
      graph.has_edge?("David", "Angela"). should be_false
      graph.has_edge?("Angela", "David"). should be_false
    end

    it "reverses an edge if the amount added exceeds the negative of the amount already there" do
      graph.add_edge("Angela", "David", 400)
      graph.owed_amount("David", "Angela").should == -200
      graph.owed_amount("Angela", "David").should == 200
    end

    describe "#remove_edge" do
      it "removes an edge" do
        graph.remove_edge("David", "Angela")
        graph.has_edge?("David", "Angela").should be_false
        graph.owed_amount("David", "Angela").should == 0
      end

      it "removes a negative edge" do
        graph.remove_edge("Angela", "David")
        graph.has_edge?("David", "Angela").should be_false
        graph.owed_amount("David", "Angela").should == 0
      end

      it "returns the owed amount" do
        graph_remove_edge("David", "Angela").should == 200
      end

      it "returns the owed amount for a negative edge" do
        graph_remove_edge("Angela", "David").should == -200
      end
    end
  end
end
