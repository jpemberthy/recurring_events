class ComplexMatcher
  attr_reader :name, :regexp, :proc

  # Creates a new ComplexMatcher with a name, a regexp and a Proc. All the
  # fields are mandatory. If you want to skip the Proc then you can use a
  # SimpleMatcher.
  # 
  # proc will be saved and applied to the text if the text matches the regexp
  # in a match call.
  def initialize(name, regexp, proc)
    @name = name
    @regexp = regexp
    @proc = proc

    validate_input
  end

  # Matches the text with the matcher's regular expression. If it matches
  # then it will apply the Proc to the text and return an array containing
  # [new_text, category] where category is the name of this matcher. Returns
  # nil if the text does not match.
  def match(text)
    if @regexp.match(text)
      [@proc.call(text), @name]
    else
      nil
    end
  end

  private
  
  # make sure we don't get empty data.
  def validate_input
    raise ComplexMatcherError.new("name can't be nil") if @name.nil?
    raise ComplexMatcherError.new("regexp can't be nil") if @regexp.nil?
    raise ComplexMatcherError.new("proc can't be nil") if @proc.nil?
  end
end

class ComplexMatcherError < StandardError
end
