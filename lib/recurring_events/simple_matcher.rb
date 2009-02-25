class SimpleMatcher
  attr_reader :name, :regexp, :match_text

  # Creates a new SimpleMatcher with name and a regexp. Both fields are
  # mandatory. If you want to apply a Proc to the resulting expression (to
  # transform it) then take a look at ComplexMatcher.
  # 
  # The matcher's name represents the text category it matches. An example of
  # this:
  # 
  #     SimpleMatcher.new(:time, /\d\d:\d\d/)
  # A call to match is usually what follows the creation of the matcher.
  def initialize(name, regexp)
    @name = name
    @regexp = regexp
    validate_input
  end

  # Matches the text against the regular expression provided in the matcher's
  # creation. If it matches then it returns an array with [text, category where
  # category is the name of the matcher. Returns nil if the text does not
  # match.
  def match(text)
    if match = @regexp.match(text)
      @match_text = match.to_s
      [match.to_s, @name]
    else
      nil
    end
  end
  alias_method :matches?, :match

  private

  # make sure we don't get empty data
  def validate_input            # :nodoc:
    raise ComplexMatcherError.new("name can't be nil") if @name.nil?
    raise ComplexMatcherError.new("regexp can't be nil") if @regexp.nil?
  end
end
