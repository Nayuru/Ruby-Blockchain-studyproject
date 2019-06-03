#Va servir à récupèrer les transactions en attente, et les retransformer en objet Transactions.
require_relative '../classes/transactions'

module TransactionsLoader

  def self.load_from_file
    list = []
    f = File.open('pendings.txt')
    f.each do |line|
      formalized = TransactionsLoader.deformalize(line)
      list << Transaction.new(formalized[1], formalized[2], formalized[3])
    end
    f.close
    list
  end

  def self.deformalize(formalized)
    formalized.split('@')
  end

  def self.flush_pendings
    puts "C'est ici que ça foire"
    File.truncate('pendings.txt', 0)

  end

  def self.add_new_tx(sender, receiver, amount)
    trans = Transaction.new(sender, receiver, amount)
    f = open('pendings.txt', 'a')
    f.puts trans.formalize
    f.close
  end
end