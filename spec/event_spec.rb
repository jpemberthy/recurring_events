require File.dirname(__FILE__) + "/spec_helper"

describe "Event" do
  before :all do
    @start_date = DateTime.civil(2012, 11, 13, 10, 58, 46)
    @end_date = DateTime.civil(2012, 11, 13, 11, 13, 46)
    @options = { 
      :start_date => @start_date, 
      :end_date   => @end_date, 
      :event_type => 'something'
    }
    @event = Event.new(@options)
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
    @event.year.should == 2012
  end

  it 'should return the date of the event' do
    @event.date.should == @start_date
  end

  it 'should default length to 60 minutes' do
    Event.new({ }).length.should == 60
  end

  it 'should return the correct length' do
    @event.length.should == 15
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

  it 'should work with Time dates' do
    e_time = Event.new({ :start_date => @start_date.to_time, :end_date => @end_date.to_time})
    e_time.day.should == @event.day
    e_time.hour.should == @event.hour
    e_time.month.should == @event.month
  end

  it 'should not allow a negative length' do
    lambda { 
      Event.new({:start_date => @end_date, :end_date => @start_date})
    }.should raise_error
  end
end
