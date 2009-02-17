class SimpleMatcher
  attr_reader :name, :regexp

  def initialize(name, regexp)
    @name = name
    @regexp = regexp
    validate_input
  end

  def match(text)
    if @regexp.match(text)
      [text, @name]
    else
      nil
    end
  end

  private
  
  def validate_input
    raise ComplexMatcherError.new("name can't be nil") if @name.nil?
    raise ComplexMatcherError.new("regexp can't be nil") if @regexp.nil?
  end
end
