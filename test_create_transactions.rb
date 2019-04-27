
#Genere des transactions aléatoires dans le fichier pendings.txt, à 2 secondes d'intervalle.
def main
  loop do
    trans = generate_transaction
    open('pendings.txt', 'a') do |f|
      f.puts trans
    end
    puts "New transaction received : #{trans}"
    sleep 2
  end
end

def generate_transaction
  accounts = ["Antoine", "Cedric", "Romain", "Clement", "Gaetan"]
  sender = accounts.sample
  receiver = accounts.sample
  amount = rand(50)

  "@#{sender}@#{receiver}@#{amount}"
end

main