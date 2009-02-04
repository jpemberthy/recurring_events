require File.dirname(__FILE__) + "/../spec_helper"

describe 'English Parser' do
  it "should recognize simple sentences with hour" do
    EventParser.parse('mr test needs a visit at 3:00pm').should_not be_nil
  end

  it 'should recognize sentences with week days and a time' do
    EventParser.parse("Mr. Fakedude needs a visit on monday morning.").should_not be_nil
  end

  it 'should recognize sentences with custom events' do
    EventParser.parse("Mr. Fakedude needs a chicken soup every day at lunch.").should_not be_nil
  end
end
