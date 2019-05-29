require 'digest'
require_relative 'database'

module KeyGenerator
  def self.new_private_key
    private_key = Array.new(64){[*"a".."z", *"0".."9"].sample}.join
    #puts "Please save your private key : #{private_key}"
    private_key
  end

  def self.new_public_key(pvt_key,psw)
    public_key = Digest::SHA256.hexdigest(pvt_key+psw)
    public_key
  end
end
