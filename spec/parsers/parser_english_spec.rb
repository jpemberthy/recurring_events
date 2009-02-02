require File.dirname(__FILE__) + "/../spec_helper"

describe 'English Parser' do
  before :all do
    @parser = EventParser
  end

  it "should recognize simple sentences with hour" do
    @parser.parse('Mr. Fakedude needs care this saturday at 3 PM.').should_not be_nil
  end

  it 'should recognize sentences with week days and a time' do
    @parser.parse("Mr. Fakedude needs a visit on monday morning.").should_not be_nil
  end

  it 'should recognize sentences with custom events' do
    @parser.parse("Mr. Fakedude needs a chicken soup every day at lunch.").should_not be_nil
  end
end
