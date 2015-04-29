require './transaction'

include Transaction

describe Calculator do
  it "calculates the correct graph for two nodes with one edge" do
    graph = Graph.new
    graph.add_node("Steven")
    graph.add_node("Crystal")
    graph.add_edge("Steven", "Crystal", 100)

    calculator = Calculator.new(graph: graph)
    calculated_graph = calculator.results
    expect(calculated_graph.owed_amount("Steven", "Crystal")).to eq(100)
  end

  it "calculates the correct graph for three nodes starting with three edges"
end
