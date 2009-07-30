class Matchers
  # Runs a text through the different text matchers. Returns an array of
  # [text, category] if it matches and an empty array if nothing matches. Raises a
  # MatchersError if no matchers were registered.
  def self.run(phrase)
    text = phrase.clone
    @matches = []
    raise MatchersError.new('No matchers registered') if no_matchers?

    # Check the text against each matcher. If the text matches then remove
    # the *original* text from the string, add its transformation to the list
    # of matches and restart the matching loop. If not we can move to the
    # next matcher. Note that original text != token text for some ComplexMatchers.
    @matchers.each do |matcher|
      if match = matcher.matches?(text)
        @matches << match
        text.sub!(/#{matcher.matched_text}/,'')
        retry
      end
    end

    @matches
  end

  # Registers a new matcher for the runner. You should call this method for
  # each one of your custom matchers, passing the matcher as the parameter.
  def self.register(matcher)
    @matchers ||= []
    @matchers << matcher
  end

  # Removes all the matchers from the runner.
  def self.clear
    @matchers = []
  end

  # Loads a collection of simple but useful matchers.
  def self.load_default_matchers
    @matchers ||= []
    @matchers << SimpleMatcher.new(:time, /\b((2[0-3])|(0|1)?\d)(:[0-5][0-9])?(am|pm)?\b/)
    @matchers << SimpleMatcher.new(:time, /(a|p)\.?m\.?/)

    @matchers << SimpleMatcher.new(:recurrency, /\b(every|each)\b/)
    @matchers << SimpleMatcher.new(:recurrency, /\b(day|week)s?\b/)

    @matchers << SimpleMatcher.new(:day, /[0-3]?[0-9](st|nd|rd|th)/)

    @matchers << ComplexMatcher.new(:time, /morning/,   lambda { "07:00" })
    @matchers << ComplexMatcher.new(:time, /\bnoon\b/,      lambda { "12:00" })
    @matchers << ComplexMatcher.new(:time, /afternoon/, lambda { "14:00" })
    @matchers << ComplexMatcher.new(:time, /night/, lambda { "20:00" })


    # Change tomorrow for the day name
    @matchers << ComplexMatcher.new(:day, /\btomorrow\b/, 
                                    lambda { (Time.now + 3600 * 24).strftime("%A") })
    # Change today for the day name
    @matchers << ComplexMatcher.new(:day, /\btoday\b/,
                                    lambda { (Time.now).strftime("%A") })
  end

  # Returns a list of the current available matchers.
  def self.matchers
    @matchers
  end

  protected
  
  def self.no_matchers?
    @matchers.nil? || @matchers.empty?
  end
end

class MatchersError < StandardError; end # :nodoc:
