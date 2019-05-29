#Va servir à récupèrer les transactions en attente, et les retransformer en objet Transactions.
require_relative '../classes/transactions'

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
    File.truncate('../pendings.txt', 0)
  end

  def self.add_new_tx(sender, receiver, amount)
    trans = Transaction.new(sender, receiver, amount)
    open('../pendings.txt', 'a') do |f|
      f.puts trans.formalize
    end
  end
end