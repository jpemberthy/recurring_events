class ComplexMatcher
  attr_reader :name, :regexp, :proc

  def initialize(name, regexp, proc)
    @name = name
    @regexp = regexp
    @proc = proc

    validate_input
  end

  def match(text)
    if @regexp.match(text)
      @proc.call(text)
    else
      nil
    end
  end

  private
  
  def validate_input
    raise ComplexMatcherError.new("regexp can't be nil") if @regexp.nil?
    raise ComplexMatcherError.new("proc can't be nil") if @proc.nil?
  end
end

class ComplexMatcherError < StandardError
end
