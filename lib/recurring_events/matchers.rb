class Matchers
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

  def self.register(matcher)
    @matchers ||= []
    @matchers << matcher
  end

  def self.clear
    @matchers = []
  end
  
  # load default matchers
  def self.load
    
  end
end

class MatchersError < StandardError; end # :nodoc:
