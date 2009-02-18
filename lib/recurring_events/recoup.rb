class Recoup
  attr_reader :matches, :to_match, :db

  def initialize(text)          # :nodoc:
    @db = Corpus.new
    @processor = Preprocessor.new(text)
    @matches = { }
    @to_match = []
    setup_categories
  end

  # Starts the parsing process for text. Returns an Event or nil if the text
  # could not be parsed.
  def self.start(text)
    self.new(text).start
  end

  # Starts the parsing process. The steps are:
  # 1. Run the text through the preprocessor which will return a clean
  # tokenized output.
  # 2. Match the tokens against the database records or against the custom
  # filters.
  # 3. ???
  # 4. Profit!
  #
  # 
  def start                     # :nodoc:
    run_corpus
    run_matchers if !@to_match.empty?
  end
  
  protected
  
  # creates the initial keys for every category in @matches
  def setup_categories          # :nodoc:
    [:event, :time, :date, :subject, :salutation, :recurrency].each do |category|
      @matches[category] = []
    end

  end

  def run_corpus
    @processor.process.each do |token|
      category = @db[token]
      if category               # the word is in the corpus
        @matches[category] ||= []
        @matches[category] << token
      else                      # we'll need to run it through the matchers
        @to_match << token
      end
    end
  end

  def run_matchers
    tokens = @to_match
    @to_match = []
    Matchers.load
    tokens.each do |token|
      text, category = Matchers.run(token)
      if !text.nil?
        @matches[category] ||= []
        @matches[category] << text
      else
        @to_match << [text, category]
      end
    end
  end
end
