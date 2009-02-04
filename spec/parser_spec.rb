# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + "/spec_helper"

describe "Parser" do
  it 'has a class method for parsing text' do
    EventParser.new('foo').parse.should == EventParser.parse('foo')
  end
end

describe "Text Normalizer" do
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

  it 'should keep a copy of the original text after modifications' do
    text = 'Some guy needs something on mondays at 4PM foo bar'
    EventParser.new(text).text.should == 'some guy needs something on mondays at 4pm foo bar'
  end

  it 'should replace common day times words with hours' do
    EventParser.new("morning noon").text.should == 'at 7:00 at 12:00'
    EventParser.new("afternoon night").text.should == 'at 14:00 at 20:00'
  end

  it 'should strip punctuation' do
    e = EventParser.new('Some,stuff. with; punctuation and that\' kind of stuff.')
    e.text.should == 'some stuff with punctuation and that kind of stuff'
  end
  
  it 'should be able to change the language if it exists' do
    e = EventParser.new('This is a test')
    e.language.should == :english
    e.language = :spanish
    e.language.should == :spanish
  end

  it 'should raise an error if it receives an unknown language' do
    e = EventParser.new('This is a test')
    lambda { 
      e.language = :swahili
    }.should raise_error(ParserError)
    e.language.should == :english
  end
end
