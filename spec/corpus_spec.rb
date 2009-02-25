require File.join(File.dirname(__FILE__), 'spec_helper')

describe Corpus do
  before :all do
    @db = Corpus.new("db_test.db")
  end

  after :all do
    @db.close
    # Make sure we remove the database after each run.
    File.unlink(@db.path)
  end

  it 'accepts symbols for value retrieval' do
    @db << ['foo', 'bar']
    @db[:foo].should == @db["foo"]
    @db[:foo].should == :bar
  end

  it 'inserts and retrieves values into the database' do
    @db.insert(['foo', 'bar'])
    @db.insert('bla', 'baz')

    @db[:foo].should == :bar
    @db[:bla].should == :baz
  end

  it 'complains on nil keys or nil values' do
    lambda { 
      @db.insert(nil, 'baz')
    }.should raise_error

    lambda { 
      @db.insert('baz', nil)
    }.should raise_error
  end

  it 'aliases get to []' do
    @db.insert('bla', 'baz')

    ret = @db[:bla]
    ret.should == @db.get(:bla)
    ret.should == :baz
  end

  it 'aliases insert to <<' do
    @db << ['foo', 'bar']
    @db[:foo].should == :bar

    lambda { 
      @db << [nil, 'baz']
    }.should raise_error

    lambda { 
      @db << ['baz', nil]
    }.should raise_error
  end

  it 'aliases insert to []=' do
    @db[:foo] = 'bar'
    @db[:foo].should == :bar

    lambda { 
      @db[nil] = 'baz'
    }.should raise_error

    lambda { 
      @db[:baz] = nil
    }.should raise_error
  end

  it 'accepts an array for insertion' do
    @db << ['foo', 'bar']
    @db[:foo].should == :bar
  end

  it 'accepts a key, value pair for insertion' do
    @db.insert('key', :category)
    @db[:key].should == :category
  end

  it 'returns nil if a record does not exist' do
    @db[:fake].should == nil
  end

  it 'saves the records' do
    @db[:test] = :bla
    @db.close
    @db.open
    @db[:test].should == :bla
  end

  it 'defaults the database file to ./db/corpus.db' do
    expected = File.join(File.dirname(__FILE__), '..', 'lib', 'recurring_events', 'db')
    Corpus.new('db_test.db').send(:default_path).should == expected
  end

  it 'loads definitions from a YAML file and inserts them into the database' do
    file = File.join(File.dirname(__FILE__), "..", "lib", "recurring_events", "corpus.yml")
    db = Corpus.new('yaml_test.db')
    db.load_yaml(file)
    db["saturday"].should == :day
    db["an"].should == :article
  end

  it 'raises an error when it cannot create the database' do
    lambda { Corpus.new("") }.should raise_error(CorpusError)
  end
end
