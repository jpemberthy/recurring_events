class Recoup
  attr_reader :matches, :to_match, :db

  def initialize(text)          # :nodoc:
    @db = Corpus.new
    @processor = Preprocessor.new(text)
    @matches = { }
    @to_match = []

    init_recoup
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
  # 3. Save the non-matched words in a database (with the full phrase).
  # 4. Returns a hash containing the extracted properties.
  def start                     # :nodoc:
    run_corpus
    run_matchers
    save_unmatched_words
    @matches
  end
  
  protected
  
  # Runs the list of tokens through the corpus and saves away the ones it
  # recognizes. Non-matched tokens will be processed by the matchers.
  def run_corpus                # :nodoc:
    tokens = @processor.process
    tokens.each do |token|
      category = @db[token]
      @matches[category] << token if category # word's in corpus.
    end
  end

  # Runs the unmatched tokens through the custom matchers and
  # saves the ones it recognizes.
  def run_matchers              # :nodoc:
    matches = Matchers.run(phrase_without_matches)
    matches.each do |match|
      text, category = match
      if text
        @matches[category] << text
      end
    end
  end

  # Save all the unmatched tokens to a database. Uses (token : original
  # phrase) pairs. 
  def save_unmatched_words      # :nodoc:
    tokens = phrase_without_matches.split(' ')
    unmatched_db = Corpus.new("unmatched-#{program_name}.db")
    tokens.each do |token|
      if !complex_token_matches?(token) # token was not transformed earlier
        @to_match << token
        unmatched_db[token] = @processor.original_text
      end
    end
    unmatched_db.close
  end

  # Returns true if the token matches against a ComplexMatcher and nil otherwise.
  def complex_token_matches?(token) # :nodoc:
    Matchers.matchers.any? {|matcher| matcher.matches?(token) }
  end

  # Removes all the words in @matched from the original text string.
  def phrase_without_matches      # :nodoc:
    string = @processor.original_text.clone.downcase
    regexp = Regexp.new(@matches.values.flatten.join("\\b|\\b"))
    string.gsub(regexp, '')
  end

  # TODO: Need a practical way to set this up.
  # Creates the initial keys for every category in @matches
  def setup_categories          # :nodoc:
    [:event, :time, :salutation, :recurrency, :preposition,
     :article, :day, :verb, :name, :number].each do |category|
      @matches[category] = []
    end
  end

  # Initialization routine, sets up the corpus and the matchers.
  def init_recoup               # :nodoc:
    setup_categories
    db.load_yaml(File.join(File.dirname(__FILE__), "corpus.yml"))
    Matchers.load_default_matchers    
  end
end
