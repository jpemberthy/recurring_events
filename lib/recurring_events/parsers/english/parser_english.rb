# Full phrase.
class PhraseNode < Treetop::Runtime::SyntaxNode # :nodoc:
  def value
    subject.value.merge(predicate.value)
  end
end

# Phrase after stripping the subject.
class PredicateNode < Treetop::Runtime::SyntaxNode # :nodoc:
  def value
    event.value.merge(time.value)
  end
end

# Subject of the phrase.
class SubjectNode < Treetop::Runtime::SyntaxNode # :nodoc:
  def value
    { :subject => text_value }
  end
end

# Event time including date and hour.
class TimeNode < Treetop::Runtime::SyntaxNode # :nodoc:
  def value
    { :time => text_value }
  end
end

# Type of event.
module EventNode # :nodoc:
  def value
    { :event => text_value }
  end
end
