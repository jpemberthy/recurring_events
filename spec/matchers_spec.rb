require File.join(File.dirname(__FILE__), 'spec_helper')

describe Matchers do
  before :all do
    @matcher = SimpleMatcher.new(:test_matcher, /\w+/)
  end
  
  it 'allows the registration of new matchers' do
    Matchers.register(@matcher)
    Matchers.instance_variable_get(:@matchers).size.should == 1
  end
  
  it 'returns nil if no match was found' do    
    Matchers.clear
    Matchers.run("text").should be_nil
  end


  it 'matches a text against all registered matchers' do
    Matchers.register(@matcher)
    Matchers.run("test").should == ['test', :test_matcher]
    Matchers.clear
  end
  
  it 'matches complex expressions' do
    cm = ComplexMatcher.new(:test_complex_matcher, /\d+/, Proc.new { |match| match.to_i })
    Matchers.register(cm)
    Matchers.run('34').should == [34, :test_complex_matcher]
  end
end

