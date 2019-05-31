require_relative 'classes/blocks'
require_relative 'classes/transactions'

require_relative 'modules/database'
require_relative 'modules/tools'
$db = Database.new
$stdout.sync = true
def main_process
  process_transactions
end

def process_transactions
  difficulty = 4
  # Va checker toutes les 5 secondes si de nouvelles transactions sont apparues dans pendings.txt, et si oui, les consumme
  # et les mine.

  loop do
    pending_transactions = TransactionsLoader.load_from_file

    unless pending_transactions.empty?
      TransactionsLoader.flush_pendings
      now = Time.now
      puts 'Found new transactions.'
      puts 'Processing block...'
      block_to_add = Block.launch_mining_process($db.get_last, pending_transactions, difficulty)
      $db.add_into_db(block_to_add)

      puts 'Processed transactions.'
      ellapsed = Time.now - now
      puts ellapsed
    end

    puts 'Waiting for new pending transactions... Next check in 10 seconds.'
    sleep 10
  end
end

def puts_exity
  puts 'Exiting...'
  sleep 2
end

main_process