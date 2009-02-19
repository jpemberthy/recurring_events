require File.join(File.dirname(__FILE__), 'spec_helper')

describe Recoup do
  before :each do
    Matchers.clear
    @parser = Recoup.new('afternoon at 3')
    @parser.db.insert('afternoon', :time)
    matcher = SimpleMatcher.new(:number, /\d+/)
    Matchers.register(matcher)
  end
  
  it 'has a class method for fast starts' do
    c = Recoup.start('some text').should == Recoup.new('some text').start
  end

  it 'uses the corpus to match tokens' do
    @parser.start
    @parser.matches[:time].should include('afternoon')
  end

  it 'uses the matchers to match the extra tokens' do
    @parser.start
    @parser.matches[:time].should include('afternoon')
    @parser.matches[:number].should include('3')
  end
  
  it 'saves away the unmatched words' do
    @parser.start
    db = Corpus.new("unmatched.db")
    db["at"].should == :"afternoon at 3"
  end
end
