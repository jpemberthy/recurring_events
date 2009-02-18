class Matchers
  def self.run(text)
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
end

