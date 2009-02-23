require File.join(File.dirname(__FILE__), 'spec_helper')

describe Preprocessor do
  it 'receives a text to process' do
    Preprocessor.new('oh hai').text.should == 'oh hai'
  end

  it 'processes the text stripping unwanted characters' do
    p = Preprocessor.new('Some,stuff. with; punctuation and that\' kind of stuff.')
    p.process
    p.text.should == 'Some stuff with punctuation and that\' kind of stuff'
  end

  it 'keeps a copy of the original text' do
    val = 'Some,stuff. with; punctuation and that\' kind of stuff.'
    p = Preprocessor.new(val)
    p.process
    p.original_text.should == val
  end

  it 'processes the text and returns a list of tokens' do
    tokens = Preprocessor.new("Hey, this is a list of tokens!").process
    tokens.should == ['hey', 'this', 'is', 'a', 'list', 'of', 'tokens!']
  end
end
