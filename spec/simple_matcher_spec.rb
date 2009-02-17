require File.join(File.dirname(__FILE__), 'spec_helper')

describe SimpleMatcher do
  before :all do
    @regexp = /[a-z][0-9]/
    @matcher = SimpleMatcher.new(:test_matcher, @regexp)
  end

  it 'has a name' do
    @matcher.name.should == :test_matcher
  end

  it 'has a regexp' do
    @matcher.regexp.should == @regexp
  end

  it 'fails if no regexp was provided' do
    lambda { 
      SimpleMatcher.new(:a, nil)
    }.should raise_error
  end

  it 'fails if no name was provided' do    
    lambda { 
      SimpleMatcher.new(nil, @regexp)
    }.should raise_error
  end

  it 'returns the text and the category when it matches' do
    @matcher.match('abc123').should == ['abc123', :test_matcher]
  end

  it 'returns nil if it does not match' do
    @matcher.match('123').should be_nil
  end
end
