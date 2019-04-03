require 'digest'
require 'date'
require_relative 'dblib'

#--------------------------------------------------------------------------
class Transaction
  attr_accessor :sender, :amount, :receiver
  def initialize(sender, amount, receiver)
    @sender = sender
    @amount = amount
    @receiver = receiver
  end
end
#--------------------------------------------------------------------------


#--------------------------------------------------------------------------
class Block
  attr_accessor :index, :timestamp, :proof, :data, :previous_hash, :hash
  def initialize(index, timestamp, proof, data, previous_hash)
    @index = index
    @timestamp = timestamp
    @proof = proof
    @data = data
    @previous_hash = previous_hash
    @hash = hash_block
  end

  def hash_block
    Digest::SHA256.hexdigest "#{@index}#{@timestamp}#{@data}#{@previous_hash}"
  end
end
#--------------------------------------------------------------------------


def display_block(block)
  puts "Index : #{block.index}, timestamp : #{block.timestamp}, proof : #{block.proof} data : #{block.data}, previous_hash : #{block.previous_hash}, hash : #{block.hash}", ''
end
#---------------------------------------------------------------------------

def create_new_transaction
  puts '(1/3) Please enter a sender : '
  sender = gets.chomp
  puts '(2/3) Please enter a receiver : '
  receiver = gets.chomp
  puts '(3/3) Please enter an amount : '
  amount = gets.chomp

  Transaction.new(sender, amount, receiver)
end
#---------------------------------------------------------------------------

def formalize_transaction(transaction)
  "@#{transaction.sender}-@#{transaction.receiver}-@#{transaction.amount}"
end
#---------------------------------------------------------------------------

def display_transactions(list)
  if list.empty?
    puts 'There is no yet transactions to be mined.', ''
  else
    puts 'The current block to mine have the following props : '
    list.each do |transaction|
      puts formalize_transaction(transaction)
    end
  end
end
#--------------------------------------------------------------------------

def create_genesis_block
  data = ['Genesis Block']
  genesis_add = Block.new(0, DateTime.now, 1, data, '0')
  puts 'Genesis Block successfully created, with props : '
  display_block(genesis_add)
  genesis_add
end
#--------------------------------------------------------------------------


#--------------------------------------------------------------------------
def proof_of_work(last_proof)
  #Ancienne methode de proof of work, elle peut etre utile à un moment,je la laisse meme si non utilisée.
  incrementer = last_proof + 1
  until (incrementer % 9).zero? && (incrementer % last_proof).zero?
    incrementer += 1
  end
  incrementer
end
#--------------------------------------------------------------------------

def proof_of_work_zeroes_method(last_proof, difficulty)
  incrementer = rand(1_000_000_000_000_000_000_000_000)
  result = Digest::SHA256.hexdigest(last_proof.to_s + incrementer.to_s)
  now = Time.now

  until result[0..difficulty-1] == '0' * difficulty
    incrementer = rand(1_000_000_000_000_000_000_000_000)
    result = Digest::SHA256.hexdigest(last_proof.to_s + incrementer.to_s)

  end
  puts "Elapsed time : #{Time.now - now}"
  incrementer
end
#---------------------------------------------------------------------------

def mine(last_block, transactions_to_add, difficulty)
  last_proof = last_block.proof
  proof = proof_of_work_zeroes_method(last_proof, difficulty)
  transaction_list = []
  transaction_list << transactions_to_add unless transactions_to_add.empty?
  data = transaction_list

  new_block_index = last_block.index + 1
  new_block_timestamp = DateTime.now
  Block.new(new_block_index, new_block_timestamp, proof, data, last_block.hash)

end
#--------------------------------------------------------------------------

