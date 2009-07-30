require File.join(File.dirname(__FILE__), 'spec_helper')

describe PhraseSet do
  before(:each) do
    @phrases = PhraseSet::PHRASES
  end
   
  it "" do
    @phrases.should_not be_empty
  end
  
  it "" do
    @phrases.first.should be_instance_of(Array)
  end
  
  it "" do
    @phrases.first.should == ["what", "menu", "today"]
  end
  
end
