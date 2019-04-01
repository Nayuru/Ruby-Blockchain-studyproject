require_relative 'blockchainlib'
blockchain = []

def main_process
  difficulty = 3
  puts_menu
  choice = gets.chomp
  transactions_to_add = []

  until choice == '4'
    case choice
      when '0'
        blockchain = [create_genesis_block]
      when '1'
        puts "Mining a new block"
        block_to_add = mine(blockchain.last, transactions_to_add, difficulty)
        blockchain << block_to_add
        puts "A new block has been added : "
        display_block(block_to_add)
      when '2'
        puts "Add a new transaction"
        transactions_to_add << create_new_transaction
      when '3'
        display_transactions(transactions_to_add)
    else
      puts "Please enter a valid input."
    end
    puts_menu
    choice = gets.chomp
  end

  save_blockchain = File.open("blocks.txt", 'wb')
  blockchain.each do |block|
    save_blockchain.write(Marshal.dump(block))
  end
  puts_exit
end

def puts_menu
  puts "0 : Create Genesis Block "
  puts "1 : Mine block"
  puts "2 : Add a new transaction"
  puts "3 : Display actual block"
  puts "4 : Exit program and erase Blockchain"
end

def puts_exit
  puts "Exiting..."
end

main_process