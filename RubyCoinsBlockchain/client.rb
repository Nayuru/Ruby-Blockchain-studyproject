require_relative 'modules/database'
require_relative 'modules/keys-generator'
require_relative 'classes/transactions'
require 'digest'
require 'faraday'
$LOGGED = false
$PVTKEY = nil
$PBCKEY = nil
require 'colorize'

String.disable_colorization = false # enable colorization

def process
  login
  unless ENV['LOGGED'] == 'false'

    puts "Welcome back, user! FYI, your pub address is " + "#{$PBCKEY}".light_yellow
    puts "Your current balance is " + "#{Database.get_balance_of_addr($PBCKEY)} coins.".light_green
    puts 'What do you want to do ? '
    loop do
      choice = 0
      display_menu
      until ["1", "2", "3"].include? choice
        choice = gets.chomp
        case choice
        when "1"
          new_trans
        when "2"
          puts "Your current balance is #{Database.get_balance_of_addr($PBCKEY)} coins."
        when "3"
          puts "Thank you! See you soon!"
          exit
        else
          puts "Please, enter a valid option."
        end
      end
    end
  end
end

def login
  if $PVTKEY == nil
    puts 'Please enter your ' + 'private key: '.light_yellow
    pvt_key = gets.chomp
    puts 'Please enter your ' + 'password: '.green
    pswd = gets.chomp
    provided_pub_addr = Digest::SHA256.hexdigest(pvt_key+pswd)
    unless Database.verify_addr_exist(provided_pub_addr).empty?
      $PVTKEY = pvt_key
      $PBCKEY = provided_pub_addr
      $LOGGED = true
    end
  end
end

def display_menu
  puts '1: New trans'.light_blue
  puts '2: See balance'.light_blue
  puts '3: Logout'.light_blue
end

def new_trans
  puts 'Please enter your public address :'
  s_pub_addr = gets.chomp
  puts 'Please enter the receiver public address:'
  r_pub_addr = gets.chomp
  # current_balance = Database.get_balance_of_addr(s_pub_addr)
  puts 'Please enter amount:'
  amount = gets.chomp
  TransactionsLoader.add_new_tx(s_pub_addr, r_pub_addr, amount)
end


def create_account
  user_private_key = KeyGenerator.new_private_key
  KeyGenerator.new_public_key(user_private_key)
  puts 'You are now registered!'
end

process