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
   attr_reader :value
   def initialize(value)
      @value = value
   end
end

# Add alias the old method to substract/add and replace the #+/#- with our
# own implementation.
# TODO clean up the code a bit.
class DateTime                  # :nodoc:
    def -(x) 
       case x
         when Hours; return DateTime.new(year, month, day, hour - x.value, min, sec)
         else;       return (self.to_time - x.to_time).to_i / 60 # use minutes
       end
    end

   def +(x) 
     return DateTime.new(year, month, day, hour + x.value, min, sec)
   end

  # converts a DateTime to a Time object.
  def to_time
    usec = (sec_fraction * 60 * 60 * 24 * (10**6)).to_i
    Time.send(:local, year, month, day, hour, min,
              sec, usec)
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
