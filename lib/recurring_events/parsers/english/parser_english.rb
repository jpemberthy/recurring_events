class PhraseNode < Treetop::Runtime::SyntaxNode # :nodoc:
  def value
    subject.value.merge(predicate.value)
  end
end

class PredicateNode < Treetop::Runtime::SyntaxNode # :nodoc:
  def value
    event.value.merge(time.value)
  end
end

class SubjectNode < Treetop::Runtime::SyntaxNode # :nodoc:
  def value
    { :subject => text_value }
  end
end

module TimeNode # :nodoc:
  def value
    { :time => text_value }
  end
end

module EventNode # :nodoc:
  def value
    { :event => text_value }
  end
end
