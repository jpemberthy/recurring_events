require File.join(File.dirname(__FILE__), 'spec_helper')

describe Matchers do
  before :all do
    @matcher = SimpleMatcher.new(:test_matcher, /\w+/)
  end
  
  it 'allows the registration of new matchers' do
    Matchers.register(@matcher)
    Matchers.instance_variable_get(:@matchers).size.should == 1
  end
  
  it 'raises an exception if no matcher was found' do    
    Matchers.clear
    lambda { 
      Matchers.run("text").should be_nil
    }.should raise_error
  end

  it 'returns nil when it does not find matches' do
    Matchers.clear
    Matchers.register(@matcher)
    Matchers.run("  ").should be_nil
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

describe "Predefined Matchers" do
  before :all do
    Matchers.clear
    Matchers.load_default_matchers
  end

  it 'includes an hour matcher' do
    ret = []
    ret << Matchers.run('15:00')
    ret << Matchers.run('6:00')
    ret << Matchers.run('06:00')
    ret << Matchers.run('06:00pm')
    ret << Matchers.run('06:00 pm')
    
    ret.collect { |p| p.first}.should == ["15:00", "6:00", "06:00", "06:00pm", "06:00 pm"]
    ret.all? { |p| p.last == :time }.should be_true
  end

  it 'includes a complex day time matcher' do
    ret = []
    Matchers.run("morning").should == ["07:00", :time]
    Matchers.run("noon").should == ["12:00", :time]
    Matchers.run("afternoon").should == ["14:00", :time]
    Matchers.run("night").should == ["20:00", :time]
  end

  it 'includes a simple recurrency matcher' do
    Matchers.run("every week").should == ["every week", :recurrency]
    Matchers.run("every 3 weeks").should == ["every 3 weeks", :recurrency]
  end
end

