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

    parser = Recoup.new('Bart needs a chicken soup every day at 3:00 PM')
    result = parser.start
    result.should  == { :day=>[],
                          :event=>["chicken", "soup"],
                          :number=>[],
                          :name=>["bart"],
                          :salutation=>[],
                          :preposition=>["at"],
                          :recurrency=>["every", "day"],
                          :time=>["3:00", "pm"],
                          :article=>["a"],
                          :verb=>["needs"]
    }
  end
end
