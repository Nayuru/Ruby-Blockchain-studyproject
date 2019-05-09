require 'digest'
require 'date'
require_relative 'transactions'
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
    until result[0..difficulty-1] == '0' * difficulty
      incrementer = rand(1_000_000_000_000_000_000_000_000)
      result = Digest::SHA256.hexdigest(last_proof.to_s + incrementer.to_s)
    end
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
