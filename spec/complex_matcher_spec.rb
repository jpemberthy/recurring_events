require File.join(File.dirname(__FILE__), 'spec_helper')

describe ComplexMatcher do
  before :all do
    @regexp = /[A-Z][0-9]/
    @proc = Proc.new { |s| s.downcase }
    @matcher = ComplexMatcher.new(:test_matcher, @regexp, @proc)
  end

  it 'has an associated regular expression' do
    @matcher.regexp.should == @regexp
  end

  it 'has an associated Proc object' do
    @matcher.proc.call('s').should == @proc.call('s')
  end

  it 'has a name' do
    @matcher.name.should == :test_matcher
  end

  it 'fails if no regexp was provided' do
    lambda { 
      ComplexMatcher.new(:a, nil, Proc.new { })
    }.should raise_error
  end

  it 'fails if no Proc was provided' do
    lambda { 
      ComplexMatcher.new(:a, /oh-hai/, nil)
    }.should raise_error
  end
  it 'fails if no name was provided' do
    lambda { 
      ComplexMatcher.new(nil, /oh-hai/, Proce.new { })
    }.should raise_error

  end

  it 'applies the Proc to the token when it matches' do
    @matcher.match('ABC123').first.should == 'abc123'

    cm = ComplexMatcher.new(:test_complex_matcher, /\d+/, Proc.new { |match| match.to_i })
    cm.match('123').first.should == 123
  end

  it 'returns the modified text and the name (category)' do
    @matcher.match('ABC123').should == ['abc123', :test_matcher]
  end
  it 'returns nil if it does not match' do
    @matcher.match('123abc').should be_nil
  end
end
