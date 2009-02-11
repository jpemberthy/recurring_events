# Treetop support for annotations (modules/classes below) is still
# sub-optimal, requiring classes for certain cases and module extension for
# others. Instead of worrying about what has to be a class and what has to be
# a module (found mostly by trial/error), we'll create a generic module
# called ClassParserNode that includes the #new method. Then we can replace
# our classes with modules and we just have to extend the ClassParserNode
# that will provide the #new method when necessary.
#
# Example:
#
#     module MyParserNode
#       extend ClassParserNode
#       def value
#         ""
#       end
#     end
# 
# With this workaround we can safely skip the class/module distinction in
# Treetop until that's fixed. For more information read:
# http://groups.google.com/group/treetop-dev/browse_thread/thread/51d18f3a19daf7d

# Generic Node for Treetop's parsing weirdness. Extend this module in your
# own module instead of creating classes/modules at random.
module ClassParserNode
  def new(*args)
    Treetop::Runtime::SyntaxNode.new(*args).extend(self)
  end
end

# Full phrase.
module PhraseNode
  extend ClassParserNode

  def value
    subject.value.merge(predicate.value)
  end
end

# Phrase after stripping the subject.
module PredicateNode
  extend ClassParserNode

  def value
    event.value.merge(time_phrase.value)
  end
end

# Subject of the phrase.
module SubjectNode
  extend ClassParserNode

  def value
    { :subject => text_value }
  end
end

module TimePhraseNode
  extend ClassParserNode

  def value
    if separator.kind_of?(RecurrencySeparator) # we need to capture the recurrency time
      { :recurrency => separator}.merge(time.value)
    else
      time.value
    end
  end
end

module RecurrencySeparator
  extend ClassParserNode
end

# Event time including date and hour.
module TimeNode
  extend ClassParserNode

  def value
    { :time => text_value }
  end
end

# Type of event.
module EventNode
  extend ClassParserNode

  def value
    { :event => text_value }
  end
end
