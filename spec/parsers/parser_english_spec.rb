require File.dirname(__FILE__) + "/../spec_helper"

describe 'English Parser' do
  before :all do
    @parser = EventParser
  end

  it "should recognize simple sentences with hour" do
    p = EventParser.new('mr test needs a visit at 3:00pm')
    ret = p.parse
    ret.should_not be_nil
  end

  it 'should recognize sentences with week days and a time' do
    @parser.parse("Mr. Fakedude needs a visit on monday morning.").should_not be_nil
  end

  it 'should recognize sentences with custom events' do
    @parser.parse("Mr. Fakedude needs a chicken soup every day at lunch.").should_not be_nil
  end
end
