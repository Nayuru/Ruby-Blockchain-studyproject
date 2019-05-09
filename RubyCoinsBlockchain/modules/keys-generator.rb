require 'digest'
require_relative 'database'

module KeyGenerator
  def self.new_private_key
    private_key = Array.new(64){[*"a".."z", *"0".."9"].sample}.join
    #puts "Please save your private key : #{private_key}"
    private_key
  end

  def self.new_public_key(pvt_key)
    puts "Please enter a password used to crypt private key and generate your public key ;"
    pswd = gets.chomp
    public_key = Digest::SHA256.hexdigest(pvt_key+pswd)
    puts 'PLEASE SAVE THESE INFORMATIONS, THEY ARE NOT RECOVERABLE!!'
    puts "Private Key is : #{pvt_key}"
    puts "Password is : #{pswd}"
    puts "Public Key is : #{public_key}"
    puts "You will be prompted these informations for any transactions!!"
    Database.add_a_new_addr(public_key)
  end
end
