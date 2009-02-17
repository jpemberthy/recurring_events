class Recoup
  def initialize(text)          # :nodoc:
    @db = Corpus.new
    @processor = Preprocessor.new(text)
    @matches = { }
    setup_categories
  end

  def self.start(text)
    self.new(text).start
  end

  def start
    to_match = []

    @processor.process.each do |token|
      category = @db[token]
      if category               # the word is in the corpus
        @matches[:category] << token
      else                      # we'll need to run it through the matchers
        to_match << token
      end
    end
    
    # TODO run the matchers on to_match
  end
  
  protected
  
  # creates the initial keys for every category in @matches
  def setup_categories
    [:event, :time, :date, :subject, :salutation, :recurrency].each do |category|
      @matches[category] = []
    end
  end

end
