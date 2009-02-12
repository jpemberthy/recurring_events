require File.dirname(__FILE__) + "/spec_helper"

describe "English Parser" do
  it "should recognize simple sentences with hour" do
    EventParser.parse('mr test needs a visit at 3:00pm').should_not be_nil
  end

  it 'should recognize sentences with week days and a time' do
    EventParser.parse("Mr. Fakedude needs a visit on monday morning.").should_not be_nil
  end

  it 'should recognize sentences with week days, a timeand custom events' do
    EventParser.parse("Mr. Fakedude needs a chicken soup on monday morning.").should_not be_nil
  end

  it 'should recognize sentences with custom events and recurrencies' do
    EventParser.parse("Mr. Fakedude needs a chicken soup every day at noon.").should_not be_nil
  end
end

describe "Language processing" do
  it "should recognize dates" do
    event = EventParser.parse('Mr. Fakedude needs a 30-minute visit on Monday 25th at 10:00 A.M.')

    event.day.should == 25
    event.month.should == Time.now.month
    event.year.should == Time.now.year
    event.hour.should == '10:00'

    event = EventParser.parse('Mr. Fakedude needs a 30 minutes visit on tuesday 26th morning for medical support.')
    event.day.should == 26
    event.month.should == Time.now.month
    event.year.should == Time.now.year
    event.hour.should == '07:00'
  end

  it "should recognize recurrencies" do
    event = EventParser.parse('Mr. Fakedude should be visited for care every day in the morning.')
    event.day.should == 1
    event.hour.should == '07:00'
    
    event = EventParser.parse('Mr. Fakedude needs a chicken soup every day at lunch.')
    event.day.should == :all
    event.hour.should == '12:00'

    event = EventParser.parse('Mr. Fakedude needs a visit to play bingo on tuesday night every 2 weeks.')
    event.day.should == :tuesday
    # find some way to specify these recurrencies
  end

  it "should recognize subjects" do
    event = EventParser.parse('Mr. Fakedude needs a visit to play bingo on tuesday night every 2 weeks.')
    event.subject.should == 'Mr. Fakedude'

    event = EventParser.parse('Mrs. Jane Fakeworth should be visited on tuesday nights every 2 weeks to play bingo.')
    event.subject.should == 'Mrs. Jane Fakeworth'
  end

  it "should recognize different event types" do
    event = EventParser.parse('Mr. Fakedude needs a 30 minutes visit on monday for medical support')
    event.type.should == "medical support"
    
    event = EventParser.parse('Mr. Fakedude needs a chicken soup every day at lunch.')
    event.type.should == "chicken soup"
  end

  it "should recognize complete phrases" do
    event = EventParser.parse('Mr. Fakedude needs a 30 minutes visit every monday morning for medical support')

    event.hour.should == '07:00'
    event.day.should == :monday
    event.recurrency.should == :every_week
    event.length.should == "30"
    event.subject.should == 'Mr. Fakedude'
    event.type.should == 'medical support'
    event.month.should == :all
    event.year.should == :all
  end
end
