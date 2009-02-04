$:.unshift File.dirname(__FILE__)

require 'recurring_events/event'
require 'recurring_events/event_parser'

require 'chronic'

require 'treetop'
require 'recurring_events/parsers/english/parser_english'
Treetop.load File.dirname(__FILE__) + "/recurring_events/parsers/english/time_english"
Treetop.load File.dirname(__FILE__) + "/recurring_events/parsers/english/parser_english"

# Custom Methods

# We'll add some syntactic sugar to the DateTime class. Make sure we use a
# new class (Hours) instead of Fixnum so the old behavior of DateTime#- and DateTime#+ still
# works. The code used for conversions is taken from the Ruby Cookbook.

# First we'll need a helper class to represent hours. This doesn't really do
# anything besides preventing the monkey patch to Fixnum.
class Hours                     # :nodoc:
   attr_reader :value
   def initialize(value)
      @value = value
   end
end

# Replace the #+/#- with our own implementation.
# TODO clean up the code a bit.
class DateTime                  # :nodoc:

  # Substract a DateTime or a number of hours from self.
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
    Time.send(:local, year, month, day, hour, min, sec, usec)
  end
end

# We also need an to_datetime method to convert Chronic Times to usable
# DateTimes.
class Time                      # :nodoc:

  # Converts a Time to a DateTime object.
  def to_datetime
    seconds = sec + Rational(usec, 10**6)
    offset = Rational(utc_offset, 60 * 60 * 24)
    DateTime.new(year, month, day, hour, min, seconds, offset)
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
