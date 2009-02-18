class Matchers
  # Runs a text through the different text matchers. Returns an array of
  # [text, category] if it matches and nil if nothing matches. raises a
  # MatchersError if no matchers were registered.
  def self.run(text)
    if @matchers.nil? || @matchers.empty?
      raise MatchersError.new('No matchers registered')
    end

    @matchers.each do |matcher| 
      match = matcher.matches?(text) 
      return match if !match.nil?
    end
    nil
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
  
  # Loads the default matchers.
  def self.load
  end
end

class MatchersError < StandardError; end # :nodoc:
