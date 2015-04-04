module Transaction
  class TransactionData
    attr_reader :ower, :owed, :amount

    def initialize(args = {})
      @ower = args[:ower]
      @owed = args[:owed]
      @amount = args[:amount]
    end

    def to_s
      "[#{ower}, #{owed}, #{amount}]"
    end
  end
end
