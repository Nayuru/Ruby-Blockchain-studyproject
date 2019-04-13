require_relative 'blockchainlib'
require_relative 'dblib'


def main_process
  difficulty = 4
  puts_menu
  choice = gets.chomp
  transactions_to_add = []
  until choice == '4'
    case choice
    when '1'
      transactions_to_add << Transaction.new(true)
      block_to_add = Block.launch_mining_process(Database.get_last, transactions_to_add, difficulty)
      Database.add_into_db(block_to_add)
      transactions_to_add = []
    when '2'
      puts 'Add a new transaction'
      transactions_to_add << Transaction.new(false)
    when '3'
      display_transactions(transactions_to_add)
  else
      puts 'Please enter a valid input.'
    end
    puts_menu
    choice = gets.chomp
  end

  puts_exit
end

def puts_menu
  puts '1 : Mine block'
  puts '2 : Add a new transaction'
  puts '3 : Display actual block'
  puts '4 : Exit program'
end

def puts_exit
  puts 'Exiting...'
  sleep 2
end

main_process