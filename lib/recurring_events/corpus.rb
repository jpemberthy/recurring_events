# Wrapper for the BerkeleyDB backend.
class Corpus
  # Loads a new corpus from an existing DB file or creates a new database if
  # the specified file is not a valid BDB database.
  def initialize(file)
  end

  # Gets the value associated with key.
  def get(key)
  end
  alias_method :[], :get

  # Inserts key:value into the database.
  def insert(key, value=nil)
  end
  alias_method :<<, :insert

  private

  # Creates a new database using name as the DB filename.
  def create_database(name)
  end

  # Opens an existing database. +file+ is the path to the DB file. The
  # default file path is "./db/corpus.db"
  def open_database(file=default_db_file)
  end

  # Close the currently opened database (if it exists).
  def close_database
  end

  def default_flags
    Bdb::DB_CREATE | Bdb::DB_INIT_LOCK | Bdb::DB_INIT_LOG  | Bdb::DB_INIT_TXN  | Bdb::DB_INIT_MPOOL
  end

  def default_db_file
    File.join(File.dirname(__FILE__), 'db')
  end
end


# env = Bdb::Env.new(0)
# env_flags =  Bdb::DB_CREATE |
#              Bdb::DB_INIT_LOCK | # Initialize locking.
#              Bdb::DB_INIT_LOG  | # Initialize logging
#              Bdb::DB_INIT_TXN  | # Initialize transactions
#              Bdb::DB_INIT_MPOOL  # Initialize the in-memory cache.

# env.open(File.join(File.dirname(__FILE__), 'tmp'), env_flags, 0);

# db = env.db
# db.open(nil, 'db1.db', nil, Bdb::Db::BTREE, Bdb::DB_CREATE | Bdb::DB_AUTO_COMMIT, 0)    

# db.put(nil, 'key', 'valorcito', 0)

# value = db.get(nil, 'key', nil, 0)
# puts value
# db.close(0)
# env.close
