include TokyoCabinet

# Wrapper for the TokyoCabinet backend.
class Corpus
  attr_reader :path
  # Loads a new corpus from an existing DB file or creates a new database if
  # the specified file is not a valid TCB database.
  def initialize(file='corpus.db')
    @path = File.join(default_path, file)
    @filename = file
    FileUtils.mkdir_p(default_path) unless File.exists?(default_path)
    create_database
  end
  
  # If there's a db for the given account_id, reopens the database.
  # If the database doesn't exist, creates a new db with the given account_id.
  def self.find_or_create_by_account_id(account_id, file="corpus.db")
    db_file = account_id + '_' + file
    self.new(db_file)
  end
  
  # Gets the value associated with key.
  def get(key)
    val = @db[key.to_s.downcase]
    if !val.nil?
      val.to_sym
    else
      nil
    end
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

    ret = @db.put(key.to_s.downcase ,value.to_s.downcase)
    if !ret
       raise CorpusError.new("#{@db.errmsg}: #{key} - #{value}")
    end
  end
  alias_method :<<, :insert
  alias_method :[]=, :insert

  # Reopens the connection to the database with the initial parameters.
  def open
    create_database
  end
  alias_method :reopen_database, :open

  # Removes a value from the database
  def delete(key)
    @db.delete(key.to_s.downcase)
  end

  # Close the database.
  def close
    @db.close
  end

  # Load a set of tokens from an existing YAML corpus.
  def load_yaml(file)
    require 'yaml'
    tokens = YAML.load_file(file)
    tokens.each do |token, category|
      @db[token] = category
    end
  end


  # Returns a hash of tokens that went into the unmatched database.
  def self.unmatched_tokens
    result = { }
    db = Corpus.new("unmatched-#{program_name}.db")
    db.instance_eval("@db").each do |k,v|
      result[k] = v
    end
    db.close
    result
  end

  protected

  # Creates a new database using name as the DB filename.
  def create_database           # :nodoc:
    @db = HDB.new
    if !@db.open(@path, default_flags)
      raise CorpusError.new("Error creating the database: #{@db.errmsg(@db.ecode)}")
    end
  end

  def default_flags             # :nodoc:
    HDB::OWRITER | HDB::OCREAT
  end

  def default_path              # :nodoc:
    File.join(File.dirname(__FILE__), 'db', 'accounts')
  end
end

class CorpusError < StandardError; end # :nodoc:
