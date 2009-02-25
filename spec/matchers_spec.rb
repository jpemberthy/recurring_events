require File.join(File.dirname(__FILE__), 'spec_helper')

describe Matchers do
  before :all do
    @matcher = SimpleMatcher.new(:test_matcher, /\b[a-z]+\b/)
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
    Matchers.run("  ").should be_empty
  end

  it 'matches a text against all registered matchers' do
    Matchers.register(@matcher)
    Matchers.run("test test").first.should == ['test', :test_matcher]
    Matchers.clear
  end
  
  it 'matches complex expressions' do
    cm = ComplexMatcher.new(:test_complex_matcher, /\d+/, Proc.new { |match| match.to_i })
    Matchers.register(cm)
    Matchers.run('34').should == [[34, :test_complex_matcher]]
  end
end

describe "Predefined Matchers" do
  before :all do
    Matchers.clear
    Matchers.load_default_matchers
  end

  it 'includes an hour matcher' do
    ret = Matchers.run('15:00 6:00 06:00 06:00pm 06:00 pm')
    ret.collect { |p| p.first}.should == ["15:00", "6:00", "06:00", "06:00pm", "06:00", "pm"]
    ret.all? { |p| p.last == :time }.should be_true
  end

  it 'includes a complex day time matcher' do
    Matchers.run("morning").should == [["07:00", :time]]
    Matchers.run("noon").should == [["12:00", :time]]
    Matchers.run("afternoon").should == [["14:00", :time]]
    Matchers.run("night").should == [["20:00", :time]]
  end

  it 'includes a simple recurrency matcher' do
    Matchers.run("every").should == [["every", :recurrency]]
    Matchers.run("day").should == [["day", :recurrency]]
    Matchers.run("everyday").should be_empty

    Matchers.run("week").should == [["week", :recurrency]]
    Matchers.run("weeks").should == [["weeks", :recurrency]]
  end

  it 'includes a date matcher' do 
    Matchers.run("1st").should == [["1st", :day]]
    Matchers.run("2nd").should == [["2nd", :day]]
    Matchers.run("3rd").should == [["3rd", :day]]
    Matchers.run("25th").should == [["25th", :day]]
  end

  it 'includes a number matcher' do
    Matchers.run("30").should == [["30", :number]]
    Matchers.run("30").should_not == [["Fakedude", :time]]
  end
end

