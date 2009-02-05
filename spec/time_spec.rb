require File.dirname(__FILE__) + "/spec_helper"

describe 'Time patches' do
  before :each do
    @date = DateTime.new(2009, 2, 1, 15, 49, 23)
    @another_date = DateTime.new(2009, 2, 1, 16, 0, 23)
  end

  it 'should allow substraction of DateTime with DateTime and return the difference in minutes' do
    ret = @another_date - @date
    ret.should == 11
  end

  it 'should allow substraction of DateTime with Hours' do
    ret = @date - 1.hour
    ret.should == DateTime.strptime("2009-02-01T14:49:23+00:00")

    lambda { 
      @date - 24.hours
    }.should raise_error(NotImplementedError)
  end

  it 'should allow conversion from DateTime to Time' do
    expected = Time.local( 2009, 2, 1, 15, 49, 23)
    @date.to_time.should == expected
  end

  it 'should allow sum of DateTime with Hours' do
    ret = @date + 1.hour
    ret.should == DateTime.new(2009, 2, 1, 16, 49, 23)
  end

  it 'should not allow sum of DateTime with DateTime' do
    lambda {
      @date + @another_date
    }.should raise_error
  end
end
