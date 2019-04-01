require 'digest'
require 'date'

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
  attr_accessor :index, :timestamp, :data, :previous_hash, :hash
  def initialize(index, timestamp, data, previous_hash)
    @index = index
    @timestamp = timestamp
    @data = data
    @previous_hash = previous_hash
    @hash = self.hash_block
  end

  def hash_block
    Digest::SHA256.hexdigest "#{@index}#{@timestamp}#{@data}#{@previous_hash}"
  end
end
#--------------------------------------------------------------------------

def display_block(block)
  puts "Index : #{block.index}, timestamp : #{block.timestamp}, data : #{block.data}, previous_hash : #{block.previous_hash}, hash : #{block.hash}", ""
end


def create_new_transaction
  puts "(1/3) Please enter a sender : "
  sender = gets.chomp
  puts "(2/3) Please enter a receiver : "
  receiver = gets.chomp
  puts "(3/3) Please enter an amount : "
  amount = gets.chomp

  Transaction.new(sender, amount, receiver)
end

def display_transactions(list)
  if list.empty?
    puts "There is no yet transactions to be mined.", ""
  else
    puts "The current block to mine have the following props : "
    x = 0
    puts list
    list.each do |transaction|
      puts "(#{x}) Sender : #{transaction.sender}, Receiver : #{transaction.receiver}, Amount : #{transaction.amount}"
      x += 1
    end
  end
end
#--------------------------------------------------------------------------
def create_genesis_block
  data = {
      #TODO: Proof of work à definir
      "proof-of-work" => 1,
      "genesis" => "block"
  }
  genesis_add = Block.new(0, DateTime.now, data, "0")
  puts "Genesis Block successfully created, with props : "
  display_block(genesis_add)
  genesis_add
end
#--------------------------------------------------------------------------



#--------------------------------------------------------------------------
def proof_of_work(last_proof)
  incrementer = last_proof + 1
  until incrementer % 9 == 0 && incrementer % last_proof == 0
    incrementer += 1
  end
  incrementer
end
#--------------------------------------------------------------------------
def proof_of_work_zeroes_method(last_proof, difficulty)
  # Find a number p' such that hash(pp') contains leading 4 zeroes, where p is the previous p'.
  incrementer = rand(1000000000000000000000000)
  result = Digest::SHA256.hexdigest(last_proof.to_s + incrementer.to_s)
  now = Time.now

  until result[0..difficulty-1] == "0"*difficulty
    incrementer = rand(1000000000000000000000000)
    result = Digest::SHA256.hexdigest(last_proof.to_s + incrementer.to_s)
    puts "Elapsed time : #{Time.now - now}"
  end
  puts result
  incrementer
end
#---------------------------------------------------------------------------
def mine(last_block, transactions_to_add, difficulty)
  last_proof = last_block.data['proof-of-work']
  proof = proof_of_work_zeroes_method(last_proof, difficulty)
  transaction_list = []
  transaction_list << transactions_to_add
  transaction_list << Transaction.new("network", "1", "miner_address")
  data = {
      "proof-of-work" => proof,
      "transactions" => transaction_list
  }
  new_block_index = last_block.index + 1
  new_block_timestamp = DateTime.now

  Block.new(new_block_index, new_block_timestamp, data, last_block.hash)
end
#--------------------------------------------------------------------------

