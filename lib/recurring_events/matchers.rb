class Matchers
  # Runs a text through the different text matchers. Returns an array of
  # [text, category] if it matches and nil if nothing matches. raises a
  # MatchersError if no matchers were registered.
  def self.run(text)
    if @matchers.nil? || @matchers.empty?
      raise MatchersError.new('No matchers registered')
    end

    @matches = []
    @matchers.each do |matcher|
      token, category = matcher.matches?(text)
      orig_token = matcher.match_text
      if !token.nil?
        @matches << [token, category]
        # replace the original text and not the token returned by the ComplexMatchers
        text.sub!(/#{orig_token}( *)?/,'')
        retry
      else
        next                   # no matches, bail out.
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
    @matchers << SimpleMatcher.new(:time, /\b((2[0-3])|(0|1)?\d):[0-5][0-9](am|pm)?\b/)
    @matchers << SimpleMatcher.new(:time, /([a]|p)\.?m\.?/)

    @matchers << SimpleMatcher.new(:recurrency, /\b(every|each)\b/)
    @matchers << SimpleMatcher.new(:recurrency, /\b(day|week)s?\b/)


    @matchers << SimpleMatcher.new(:day, /[0-3]?[0-9] ?(st|nd|rd|th)/)
    @matchers << SimpleMatcher.new(:number, /\b\d+\b/)

    @matchers << ComplexMatcher.new(:time, /morning/,   lambda { "07:00" })
    @matchers << ComplexMatcher.new(:time, /\bnoon\b/,      lambda { "12:00" })
    @matchers << ComplexMatcher.new(:time, /afternoon/, lambda { "14:00" })
    @matchers << ComplexMatcher.new(:time, /night/, lambda { "20:00" })
  end
end

class MatchersError < StandardError; end # :nodoc:
