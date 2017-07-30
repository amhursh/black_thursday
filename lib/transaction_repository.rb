class TransactionRepository

  attr_reader :sales_engine,
              :file_path,
              :id_repo

  def initialize(file_path, sales_engine)
    @file_path    = file_path
    @sales_engine = sales_engine
    @id_repo      = id_repo
  end

  def load_repo
    CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
      transaction_identification = row[:id]
      transaction = Transaction.new(row, self)
      @id_repo[transaction_identification.to_i] = transaction
    end
  end

end
