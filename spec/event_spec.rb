require File.dirname(__FILE__) + "/spec_helper"

describe "Event" do
  before :all do
    @date = DateTime.civil(2112, 11, 13, 10, 58, 46)
    @event = Event.new("", "", @date)
  end

  it 'should return the hour of the event' do
    @event.hour.should == '10:58'
  end

  it 'should return the day of the event' do
    @event.day.should == 13
  end

  it 'should return the month of the event' do
    @event.month.should == 11
  end

  it 'should return the year of the event' do
    @event.year.should == 2112
  end

  it 'should return the date of the event' do
    @event.date.should == @date
  end

  it 'should return the length of the event' do
    @event.length.should be_kind_of(Fixnum)
  end

  it 'should default length to 60 minutes' do
    @event.length.should == 60
  end

  it 'should return the type of the event' do
    @event.type.should be_kind_of(String)
  end

  it 'should return the subject of the event' do
    @event.subject.should be_kind_of(String)
  end

  it "should default subject to an empty string" do
    @event.subject.should == ''
  end
end
