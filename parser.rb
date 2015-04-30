module Transaction
  class Parser
    attr_reader :path

    def initialize(args={})
      @path = args[:filepath]
    end

    def data
      @data ||= parse_data
    end

    private
      def parse_data
        read_data = []

        File.readlines(path).each do |line|
          next if line.strip.empty?
          ower, owed, amount = line.match(/\s*(\w+)\s*->\s*(\w+)\s*\$(\d+\.?\d*)/).captures

          read_data << TransactionData.new(ower: ower, owed: owed, amount: amount.to_f)
        end

        read_data
      end
  end
end
