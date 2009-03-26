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
                          :verb=>["needs"],
                          :guessing => false
    }

    parser.to_match.should be_empty

    parser = Recoup.new('Bart needs an injection every week at 10 AM')
    result = parser.start
    result.should  == { :day=>[],
                          :event=>["injection"],
                          :number=>[],
                          :name=>["bart"],
                          :salutation=>[],
                          :preposition=>["at"],
                          :recurrency=>["every", "week"],
                          :time=>["10", "am"],
                          :article=>["an"],
                          :verb=>["needs"],
                          :guessing => false
    }

    parser.to_match.should be_empty

    parser = Recoup.new("andre needs a chicken soup every monday at 10 am")
    result = parser.start
    result.should  == { :day=>["monday"],
                          :event=>["chicken", "soup"],
                          :number=>[],
                          :name=>["andre"],
                          :salutation=>[],
                          :preposition=>["at"],
                          :recurrency=>["every"],
                          :time=>["10", "am"],
                          :article=>["a"],
                          :verb=>["needs"],
                          :guessing => false
    }

    parser.to_match.should be_empty
  end
end

describe "Custom Events Parser" do
  it "parses custom events" do
    parser = Recoup.new("Phil has a headache tomorrow at 10 am")
    ret = parser.start
    ret[:event].should == "headache"
    ret[:guessing].should == true
  end

  it "parses multi-word events" do
    parser = Recoup.new("Phil has a bad fucking headache tomorrow at 10 am")
    ret = parser.start
    ret[:event].should == "bad fucking headache"
    ret[:guessing].should == true
  end
end
