require_relative 'blockchainlib'
require_relative 'dblib'
require_relative 'tools'

def main_process
  process_transactions
end

def process_transactions
  difficulty = 5
  # Va checker toutes les 5 secondes si de nouvelles transactions sont apparues dans pendings.txt, et si oui, les consumme
  # et les mine.

  loop do
    pending_transactions = TransactionsLoader.load_from_file

    unless pending_transactions.empty?
      TransactionsLoader.flush_pendings
      puts 'Found new transactions.'
      puts 'Processing block...'
      block_to_add = Block.launch_mining_process(Database.get_last, pending_transactions, difficulty)
      Database.add_into_db(block_to_add)
      puts 'Processed transactions.'
    end

    puts 'Waiting for new pending transactions...'
    sleep 5.0
  end
end

def puts_exit
  puts 'Exiting...'
  sleep 2
end

main_process