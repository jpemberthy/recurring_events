# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + "/spec_helper"

describe "Parser" do
  it 'should recognize the correct language' do
    EventParser.new('this is an english text...').language.should == :english
    EventParser.new('esto es español...').language.should == :spanish
    EventParser.new('Dhr. Nepgast heeft maandag een...').language.should == :dutch
  end

  it 'should downcase the text' do
    EventParser.new('Some Interesting Text').text == 'some interesting text'
    EventParser.new('Un texto Interesante').text == 'un texto interesante'
  end

  it 'should replace number words with numbers' do
    EventParser.new('one two three').text.should == '1 2 3'
    EventParser.new('thirty one').text.should == '31'
    EventParser.new('not a number').text.should == 'not a number'
  end

  it 'should remove unused words' do
    text = 'Some guy needs something on mondays at 4PM foo bar'
    EventParser.new(text).text.should == 'Some guy needs something on mondays at 4PM'
  end

  it 'should replace common day times words with hours' do
    EventParser.new("morning noon").text.should == '7:00 12:00'
    EventParser.new("afternoon night").text.should == '14:00 20:00'
  end
end
