require 'sinatra'
require 'json'
require 'faraday'
require_relative 'modules/database'
require_relative 'modules/tools'
require_relative 'modules/keys-generator'
$db = Database.new
$stdout.sync = true
set :port, 4567

def listen_for_blockchains
  get '/blockchain' do
    puts "New peer with a bigger blockchain has been found. Downloading the new blockchain..."
    reponse = Faraday.get 'http://localhost:6644/new/bc'
    File.open('qzdqdzdzdqd.db', 'wb') { |fp| fp.write(reponse.body) }
    puts "Downloading done!"
  end
end

def create_users
  get '/new/user' do
    psw = params['psw']
    private_key = KeyGenerator.new_private_key
    public_key = KeyGenerator.new_public_key(private_key, psw)
    content_type :json
    $db.add_a_new_addr(public_key)
    #Penser à rajouter les users dans la db
    {pvtkey: private_key, pbckey: public_key}.to_json
  end
end

def create_transactions
  get '/new/tx' do
    sender = params['s']
    receiver = params['r']
    amount = params['a']
    puts "Received a new transaction, adding it to the pendings transactions."
    TransactionsLoader.add_new_tx(sender, receiver, amount)
    content_type :json
    {success: true, sender: sender, receiver: receiver, amount: amount}.to_json
  end
end

def check_if_user_exist
  get '/login' do
    public_key = params['pbc']
    pass = params['psw']
    result = $db.verify_addr_exist(public_key, pass)
    content_type :json
    { success: result}.to_json
  end
end

def get_all_transactions
  get '/transactions/:user' do
    addr = params['user']
    result = $db.get_all_transactions(addr)
    list = {}
    puts result.inspect
    result.each_with_index { |tx, index|
      list = list.merge(index => {sender: tx[1], receiver: tx[2], amount: tx[3]})
      puts list.inspect
    }
    content_type :json
    list.to_json
  end
end


def get_balance
  get '/amount/:user' do
    pubkey = params['user']
    result = $db.get_balance_of_addr(pubkey)
    content_type :json
    {balance: result}.to_json
  end
end



listen_for_blockchains
create_transactions
get_balance
check_if_user_exist
create_users
get_all_transactions