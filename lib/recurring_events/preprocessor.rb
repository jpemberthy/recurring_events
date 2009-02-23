class Preprocessor
  attr_reader :text
  attr_reader :original_text
  # Creates a new preprocessor to deal with the tokenization and the cleaning
  # of the text. The processor strips out all the discardable characters
  # (commas, semicolons, dashes, etc.) and returns an array of tokens by using
  # the process instance method.
  def initialize(text)
    @text = text
  end

  # Strips the unwanted characters from the text and splits the text into a
  # token list.
  def process
    @original_text = @text
    strip_characters
    tokenize
  end

  private

  # Returns an array of the tokens from the text.
  def tokenize                  # :nodoc:
    @text.split.map { |token| token.downcase }
  end
  
  # Removes all the unwanted characters (commas, semicolons, dashes,
  # etc). These might be useful if the context is to be kept but right now we
  # don't deal with that.
  def strip_characters          # :nodoc:
    @text.gsub!(/[.,;]([ ])?/, $1 || ' ')
#    @text.gsub!(/\b(a|p) m\b/, "\\1" + 'm')    # TODO Move to a matcher
    @text.rstrip!
  end
end
