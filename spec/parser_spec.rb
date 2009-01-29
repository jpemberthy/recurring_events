require File.dirname(__FILE__) + "/spec_helper"

describe "Parser" do
  it 'should downcase the text' do
    EventParser.new('Some Interesting Text').downcase.should == 'some interesting text'
  end

  it 'should replace number words with numbers' do
    EventParser.new('one two three').replace_numbers.text.should == '1 2 3'
    EventParser.new('thirty one').replace_numbers.text.should == '31'
    EventParser.new('not a number').replace_numbers.text.should == ''
  end

  it 'should replace ordinal words with ordinal numbers' do
    EventParser.new('third fourth').numericize.text.should == '3rd 4th'
    EventParser.new('first second').numericize.text.should == '1st 2nd'
  end

  it 'should remove unused words' do
    text = 'Someone needs something on mondays at 4PM foo bar'
    EventParser.new(text).strip_extra_words.text.should == 'Someone needs something on mondays at 4PM'
  end
  it 'should replace common words with hours' do
    EventParser.new("morning noon").normalize_hours.text.should == '7:00 12:00'
    EventParser.new("afternoon night").normalize_hours.text.should == '14:00 8:00'
  end
end
