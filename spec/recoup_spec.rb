require File.join(File.dirname(__FILE__), 'spec_helper')

describe Recoup do
  before :each do
    Matchers.clear
    @parser = Recoup.new('monday at 3')
    matcher = ComplexMatcher.new(:number, /\d/, Proc.new { |n| n.strip })
    Matchers.register(matcher)
  end

  it 'has a class method alias for a fast start' do
    c = Recoup.start('some text').should == Recoup.new('some text').start
  end

  it 'uses the corpus to match tokens' do
    @parser.start
    @parser.matches[:day].should include('monday')
  end

  it 'saves away the unmatched words' do
    ret = Recoup.start('unmatched afternoon')
    db = Corpus.new("unmatched-spec.db")
    db["unmatched"].should == :"unmatched afternoon"
    db.close
  end

  it 'returns a hash with the found properties' do
    ret = @parser.start
    ret.should be_kind_of(Hash)
    ret.should include(:preposition)
    ret.should include(:day)
  end

  it 'parses complex sentences' do
    ret = Recoup.start("Mr. Bart needs a chicken soup every day at 3:00 PM")
    ret.should == { 
      :article => ["a"], :time => ["3:00", "pm"], :number => [],
      :day => [], :verb => ["needs"], :name => ["bart"], :preposition => ["at"],
      :recurrency => ["every", "day"], :event => ["chicken", "soup"],
      :salutation => ["mr"], :guessing => false,
      :interrogation => []
    }

    ret = Recoup.start("Every three weeks")
    ret[:recurrency].should include("every")
    ret[:recurrency].should include("three")
    ret[:recurrency].should include("weeks")

    ret = Recoup.start("biweekly meetings")
    ret[:recurrency].should include("biweekly")
  end

  it 'saves unmatched words in @to_match' do
    Matchers.register(SimpleMatcher.new(:time, /foo/))
    p = Recoup.new('3 bla foo') 
    ret = p.start
    p.to_match.should == ['bla']
    p.to_match.should_not include('foo')
    p.to_match.should_not include('3')
  end

  it 'removes the original ComplexMatcher matches from @to_match' do
    parser = Recoup.new('Daniel needs a biweekly visit in the morning')
    result = parser.start
    parser.to_match.should_not include('morning')
    parser.to_match.should_not include('07:00')

    result[:time].should include('07:00')
  end
  
  it "should find an answer for the given text." do
    parser1 = Recoup.new("hey guys what is the menu today?")
    parser2 = Recoup.new("what do you have today in the menu?")
    result1 = parser1.start
    result2 = parser2.start
    parser1.get_answer.should == parser2.get_answer
    parser1.get_answer.should == "chineese food"
  end
  
  it "should notify a question without answer" do
    parser1 = Recoup.new("Are you Skynet?")
    result = parser1.start
    parser1.get_answer.should == "Kacatua doesn't know the answer!!"
  end
  
end
