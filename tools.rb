#Va servir à récupèrer les transactions en attente, et les retransformer en objet Transactions.

module TransactionsLoader

  def self.load_from_file
    list = []
    File.open('pendings.txt').each do |line|
      formalized = TransactionsLoader.deformalize(line)
      list << Transaction.new(formalized[1], formalized[2], formalized[3])
    end
    list
  end

  def self.deformalize(formalized)
    formalized.split('@')
  end

  def self.flush_pendings
    File.truncate('pendings.txt', 0)
  end
end