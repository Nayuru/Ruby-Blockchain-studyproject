require 'digest'
require 'date'
require_relative 'dblib'

#--------------------------------------------------------------------------
class Transaction
  attr_accessor :sender, :amount, :receiver

  def initialize(is_default = false)
    if !is_default
      puts '(1/3) Please enter a sender : '
      @sender = gets.chomp
      puts '(2/3) Please enter a receiver : '
      @receiver = gets.chomp
      puts '(3/3) Please enter an amount : '
      @amount = gets.chomp
    else
      @sender = 'network' # Le 'network' peut créer de la monnaie ex-nihilo
      @receiver = 'miner' # A remplacer par l'id de la personne qui a miné le bloc et donc lancer le programme.
      @amount = 'x' # Montant de la récompense pour avoir miné un bloc.
    end
  end

  def formalize
    "@#{@sender}-@#{@receiver}-@#{@amount}"
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

  def self.proof_of_work_generation(last_proof, difficulty)
    incrementer = rand(1_000_000_000_000_000_000_000_000)
    result = Digest::SHA256.hexdigest(last_proof.to_s + incrementer.to_s)
    begining_time = Time.now
    until result[0..difficulty-1] == '0' * difficulty
      incrementer = rand(1_000_000_000_000_000_000_000_000)
      result = Digest::SHA256.hexdigest(last_proof.to_s + incrementer.to_s)
    end
    puts "Elapsed time : #{Time.now - begining_time}"
    incrementer
  end

  def self.launch_mining_process(last_block, transactions_to_add, difficulty)
    last_proof = last_block.proof
    proof = self.proof_of_work_generation(last_proof, difficulty)
    transaction_list = []
    transaction_list << transactions_to_add unless transactions_to_add.empty?
    Block.new(last_block.index + 1, DateTime.now, proof, transaction_list, last_block.hash)
  end

  def display
    puts "Index : #{index}, timestamp : #{timestamp}, proof : #{proof} data : #{data}, previous_hash : #{previous_hash}, hash : #{hash}", ''
  end
end
#--------------------------------------------------------------------------


def display_transactions(list)
  if list.empty?
    puts 'There is no yet transactions to be mined.', ''
  else
    puts 'The current block to mine have the following props : '
    list.each do |transaction|
      puts transaction.formalize
    end
  end
end
