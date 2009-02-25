class Recoup
  attr_reader :matches, :to_match, :db

  def initialize(text)          # :nodoc:
    @db = Corpus.new
    @processor = Preprocessor.new(text)
    @matches = { }
    @to_match = []
    setup_categories

    corpus = File.join(File.dirname(__FILE__), "corpus.yml")
    db.load_yaml(corpus)
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
  # 4. ??
  # 5. Returns a hash containing the extracted properties.
  def start                     # :nodoc:
    run_corpus
    run_matchers if !@to_match.empty?
    save_unmatched_words if !@to_match.empty?
    @matches
  end
  
  protected
  
  # creates the initial keys for every category in @matches
  def setup_categories          # :nodoc:
    [:event, :time, :subject, :salutation, :recurrency].each do |category|
      @matches[category] = []
    end
  end

  # Runs the list of tokens through the corpus and saves away the ones it
  # recognizes. Non-matched tokens go into @to_match to pass them through the
  # matchers.
  def run_corpus                # :nodoc:
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

  # Runs the @to_match list of tokens through the different matchers and
  # saves the ones it recognizes in @matches.
  def run_matchers              # :nodoc:
    phrase = remove_matched(@processor.original_text.clone)
    Matchers.load_default_matchers
    matches = Matchers.run(phrase)
    matches.each do |match|
      text,category = match
      if !text.nil?
        @matches[category] ||= []
        @matches[category] << text
        phrase.sub(text, '')
      else
        @to_match << text

    end
    end
  end

  # Write all the words in @to_match to a database. Saves them as 
  # (token : original phrase) pairs. Useful for future improvementes.
  def save_unmatched_words      # :nodoc:
    db = Corpus.new("unmatched.db")
    text = @processor.original_text
    @to_match.each do |token|
      db[token] = text
    end
    db.close
  end

  def remove_matched(string)
    @matches.each do |match_array|
      match_array.last.each do |match|
        string.gsub!(match, '')
      end
    end
    string
  end
end
