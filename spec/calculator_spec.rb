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

  # TODO: This isn't really accurate
  it "calculates the correct amount for the Disney World example that inspired this project" do
    graph = Graph.new
    graph.add_node("P").add_node("B").add_node("D").add_node("J")

    graph.add_edge("J", "P", 48.82)
    graph.add_edge("J", "B", 12)
    graph.add_edge("B", "P", 267.04)
    graph.add_edge("D", "P", 46.17)
    graph.add_edge("D", "J", 197.57)
    graph.add_edge("D", "B", 9)

    results = Calculator.new(graph: graph).results
    # expect(results.total_owed_amount("P")).to eq(0)
    # expect(results.total_owed_amount("B")).to eq(0)
    # expect(results.total_owed_amount("D")).to eq(0)
    # expect(results.total_owed_amount("J")).to eq(0)
  end
end
