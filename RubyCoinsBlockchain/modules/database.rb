require 'sqlite3'

# Module destine à l'utilisation de la DB, toutes les opérations
# de connection à la DB doivent etre faites ici.
module Database
  def self.add_into_db(block)
    db = SQLite3::Database.open 'test.db'

    # Ajout du bloc dans la table 'Blocks'
    query_block = "INSERT INTO Blocks VALUES('#{block.index}', '#{block.timestamp}', '#{block.proof}', '#{block.previous_hash}', '#{block.hash}')"
    db.execute query_block


    block.data.each do |transaction|
      # Ajout des transactions dans la table 'Transactions'
      transaction.each do |datas|
        query_transaction = "INSERT INTO Transactions VALUES('#{block.index}', '#{datas.sender}', '#{datas.receiver}', '#{datas.amount}', '#{datas.timestamp}', '#{datas.hash}')"
        db.execute query_transaction
      end
    end

  rescue SQLite3::Exception => e
    puts 'Unexpected error. Please verify the database state or the query.'
    puts "Error : #{e}"
  ensure
    db.close if db
  end


  # Effectue une requete pour récupérer la dernier élement ajouté
  def self.get_last
    db = SQLite3::Database.open 'test.db'
    query = 'SELECT * FROM Blocks WHERE ID = (SELECT MAX(ID) FROM Blocks)'
    result = db.execute query
    Block.new(result[0][0], result[0][1], result[0][2], result[0][3], result[0][4])
  rescue SQLite3::Exception => e
    puts 'Could not load last block in database. Please check the following message for more information : '
    puts "Error : #{e}"
  ensure
    db.close if db
  end

  def self.get_balance_of_addr(addr)
    total = 0
    db = SQLite3::Database.open 'test.db'
    query = "SELECT * FROM Transactions WHERE RECEIVER = '#{addr}'"
    result = db.execute query

    result.each do |trans|
      total += trans[3].to_i
    end
    query = "SELECT * FROM Transactions WHERE SENDER = '#{addr}'"
    result = db.execute query
    result.each do |trans|
      total -= trans[3].to_i
    end
    total
  end

  def self.add_a_new_addr(addr)
    db = SQLite3::Database.open "test.db"
    query = "INSERT INTO PubAddresses VALUES('#{addr}')"
    db.execute query
  end

  def self.verify_addr_exist(addr)
    db = SQLite3::Database.open 'test.db'
    query = "SELECT * FROM PubAddresses WHERE publicKeys = '#{addr}'"
    result = db.execute query
    result
  end

end
