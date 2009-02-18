require File.join(File.dirname(__FILE__), 'spec_helper')

describe Recoup do
  before :each do
    @parser = Recoup.new('afternoon at 3')
    @parser.db.insert('afternoon', :time)
    matcher = SimpleMatcher.new(:number, /\d+/)
    Matchers.register(matcher)
  end

  it 'uses the corpus to match tokens' do
    @parser.start
    @parser.matches[:time].should include('afternoon')
  end

  it 'uses the matchers to match the extra tokens' do
    @parser.start
    @parser.matches[:time].should include('afternoon')
    @parser.matches[:number].should include('3')
  end
end
