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

  # TODO: This will be another algorithm
  it "minimizes the amount of work people without existing debts have to do" do
    graph = Graph.new
    %w[Steven Crystal Amy].each {|name| graph.add_node(name)}
    graph.add_edge("Steven", "Crystal", 100)
    graph.add_edge("Steven", "Amy", 200)

    calculator = Calculator.new(graph: graph)
    calculated_graph = calculator.results
    expect(calculated_graph.owed_amount("Steven", "Crystal")).to eq(100)
    expect(calculated_graph.owed_amount("Steven", "Amy")).to eq(200)
  end

  it "calculates the correct graph for three nodes starting with three edges"
end
