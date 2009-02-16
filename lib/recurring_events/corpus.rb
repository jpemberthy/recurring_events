# Wrapper for the BerkeleyDB backend.
class Corpus
  attr_reader :path
  # Loads a new corpus from an existing DB file or creates a new database if
  # the specified file is not a valid BDB database.
  def initialize(file='corpus.db')
    @path = File.join(default_path, file)
    @filename = file
    create_environment
    create_database
  end

  # Gets the value associated with key.
  def get(key)
    @db.get(nil, key.to_s, nil, 0)
  end
  alias_method :[], :get

  # Inserts key:value into the database.
  def insert(key, value=nil)
    if key.kind_of?(Array)
      key, value =  key
    end
    if key.nil? || value.nil?
      raise CorpusError.new("Invalid key/value: #{key} - #{value}")
    end
    @db.put(nil, key.to_s, value, nil)
  end
  alias_method :<<, :insert
  alias_method :[]=, :insert

  # Reopens the connection to the database with the initial parameters.
  def open
    create_environment
    create_database
  end
  alias :reopen, :open

  # Close the database and the environment.
  def close
    @db.close(0)
    @bdb_env.close
  end

  private

  # Sets up a new BDB environment
  def create_environment
    @bdb_env = Bdb::Env.new(0)
    FileUtils.mkdir_p(default_path) unless File.exists?(default_path)
    @bdb_env.open(default_path, default_flags, 0)
  end

  # Creates a new database using name as the DB filename.
  def create_database
    @db = @bdb_env.db
    if File.exists?(@path)      # database already exists, just open it
      @db.open(nil, @filename, nil, Bdb::Db::BTREE, 0, 0)
    else
      @db.open(nil, @filename, nil, Bdb::Db::BTREE, Bdb::DB_CREATE | Bdb::DB_AUTO_COMMIT, 0)
    end
  end

  # Opens an existing database. +file+ is the path to the DB file. The
  # default file path is "./db/corpus.db"
  def open_database(file=default_path)
  end

  # Close the currently opened database (if it exists).
  def close_database
  end

  def default_flags
    Bdb::DB_CREATE | Bdb::DB_INIT_LOCK | Bdb::DB_INIT_LOG  | Bdb::DB_INIT_TXN  | Bdb::DB_INIT_MPOOL
  end

  def default_path
    File.join(File.dirname(__FILE__), 'db')
  end
end

class CorpusError < StandardError; end
