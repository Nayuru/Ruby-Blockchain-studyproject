require 'digest'
require 'date'

#--------------------------------------------------------------------------
class Transaction
  attr_accessor :sender, :receiver, :amount, :hash, :timestamp # :signature

  def initialize(sender, receiver, amount)
    @sender = sender
    @receiver = receiver
    @amount = amount
    @timestamp = Time.now
    @hash = Digest::SHA256.hexdigest(@sender + @receiver + @amount.to_s)
    # @signature = signature
  end

  def formalize
    "@#{@sender}@#{@receiver}@#{@amount}"
  end

end
#--------------------------------------------------------------------------

