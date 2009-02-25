require File.join(File.dirname(__FILE__), 'spec_helper')

describe Recoup do
  before :each do
    Matchers.clear
    @parser = Recoup.new('afternoon at 3')
    matcher = ComplexMatcher.new(:number, /\d/, Proc.new { |n| n.strip })
    Matchers.register(matcher)
  end
  
  it 'has a class method alias for a fast start' do
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
    parser = Recoup.new('unmatched afternoon')
    parser.start
    db = Corpus.new("unmatched.db")
    db["unmatched"].should == :"unmatched afternoon"
  end

  it 'returns a hash with the found properties' do
    ret = @parser.start
    ret.should be_kind_of(Hash)
    ret.should include(:preposition)
    ret.should include(:time)
  end

  it 'parses complex sentences' do
    ret = Recoup.start("Mr. Bart needs a chicken soup every day at 3:00 PM")
    ret.should == {:article=>["a"], :time=>["3:00", "pm"], :number=>[], :day=>[], :verb=>["needs"], :name=>["bart"], :preposition=>["at"], :recurrency=>["every", "day"], :event=>["chicken", "soup"], :salutation=>["mr"]}
  end
end
