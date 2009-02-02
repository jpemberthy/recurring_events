class PhraseNode < Treetop::Runtime::SyntaxNode
  def value
    subject.value.merge(predicate.value)
  end
end

class PredicateNode < Treetop::Runtime::SyntaxNode
  def value
    event.value.merge(time.value)
  end
end

class SubjectNode < Treetop::Runtime::SyntaxNode
  def value
    { :subject => text_value }
  end
end

module TimeNode
  def value
    { :time => text_value }
  end
end

module EventNode
  def value
    { :event => text_value }
  end
end
