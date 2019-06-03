require 'json'
require 'faraday'
require_relative 'modules/database'
require_relative 'modules/tools'
$db = Database.new
$stdout.sync = true

def send_length
  puts "Beginning to send length to peers each 10 seconds..."
  loop do

    length = $db.get_last_id
    begin
      r = Faraday.get "http://localhost:6644/get/bclength?len=#{length}"
      puts "Pinged peers with actual blockchain."
    rescue
      puts "Could not reach node.js endpoint on 'http://localhost:6644' when sending 'length' ping."
    end
    sleep 10
  end
end

send_length