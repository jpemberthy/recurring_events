require File.join(File.dirname(__FILE__), 'spec_helper')

describe Corpus do
  before :all do
    @path = File.dirname(__FILE__), "db", "db_test"
    @db = Corpus.new(@path)
  end

  before :each do
    #clean database
  end

  after :all do
    #remove db file
  end

  it 'accepts symbols for value retrieval' do
    @db << ['foo', 'bar']
    @db[:foo].should == @db["foo"]
    @db[:foo].should =='bar'
  end

  it 'inserts and retrieves values into the database' do
    @db.insert(['foo', 'bar'])
    @db.insert('bla', 'baz')

    @db[:foo].should == 'bar'
    @db[:bla].should == 'baz'
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
    ret.should == 'baz'
  end

  it 'aliases insert to <<' do
    @db << ['foo', 'bar']
    @db[:foo].should == 'bar'

    lambda { 
      @db << [nil, 'baz']
    }.should raise_error

    lambda { 
      @db << ['baz', nil]
    }.should raise_error
  end

  it 'accepts an array for insertion' do
    @db << ['foo', 'bar']
    @db[:foo].should == 'bar'
  end

  it 'accepts a key, value pair for insertion' do
    @db.insert('key', 'value')
    @db[:key].should == 'value'
  end

  it 'defaults the database file to ./db/corpus.db' do
    expected = File.join(File.dirname(__FILE__), '..', 'lib', 'recurring_events', 'db')
    Corpus.new('foo').send(:default_db_file).should == expected
  end
end
