require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Test Phrases" do
  it 'processes complex phrases' do
    parser = Recoup.new('Daniel needs a biweekly visit in the morning')
    result = parser.start
    expected = { :recurrency=>["biweekly"], 
                 :preposition=>["in", "the"], 
                 :time=>["07:00"], 
                 :number=>[], 
                 :day=>[], 
                 :article=>["a"], 
                 :name=>["daniel"], 
                 :verb=>["needs"], 
                 :event=>["visit"], 
                 :salutation=>[]
    }
    parser.to_match.should be_empty
  end
end
