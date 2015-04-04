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
  end
end
