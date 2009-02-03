$:.unshift File.dirname(__FILE__)    

require 'recurring_events/event'
require 'recurring_events/event_parser'
require 'recurring_events/numerizer'

require 'treetop'
require 'recurring_events/parsers/english/parser_english'
Treetop.load File.dirname(__FILE__) + "/recurring_events/parsers/english/time_english"
Treetop.load File.dirname(__FILE__) + "/recurring_events/parsers/english/parser_english"

require 'date'

# We'll add some syntactic sugar to the DateTime class. Make sure we use a
# new class (Hours) instead of Fixnum so the old behavior of DateTime#- and DateTime#+ still
# works.
class Hours                     # :nodoc:
   attr_reader :hour
   def initialize(hour)
      @hour = hour
   end
end


# Add alias the old method to substract/add and replace the #+/#- with our
# own implementation.
class DateTime                  # :nodoc:
   alias_method :substract, :-
   alias_method :add, :+
   def -(hrs) 
      case hrs
        when Hours; return DateTime.new(year, month, day, hour - hrs.hour, min, sec)
        else;       return self.subtract(hrs) # fallback to the old behavior.
      end
   end

   def +(hrs) 
      case hrs
        when Hours; return DateTime.new(year, month, day, hour + hrs.hour, min, sec)
        else;       return self.add(hrs) 
      end
   end
end

# Finally add the new method to Fixnum. This allows us to do something like:
#     DateTime.new + 5.hours
class Fixnum                  # :nodoc:

   def hours
      Hours.new(self)
   end
  alias_method :hour, :hours
end
