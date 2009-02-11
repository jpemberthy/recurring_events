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
  # Return the difference in minutes between between two DateTimes or between
  # DateTime and Hours.
  def -(x)
    case x
      when Hours; substract_dates(x)
      else;       return ((self.to_time - x.to_time).to_i / 60.0).round # use minutes
    end
  end

  # Adds x minutes to self.
  def +(x) 
    return DateTime.new(year, month, day, hour + x.value, min, sec)
  end

  # Converts  self to a Time object.
  def to_time
    usec = (sec_fraction * 60 * 60 * 24 * (10**6)).to_i
    Time.send(:local, year, month, day, hour, min, sec, usec)
  end

  protected

  # Add full days instead of an invalid number of hours if hours > 23.
  def substract_dates(other)    # :nodoc:
    if hour - other.value <= 0  
      raise NotImplementedError.new # TODO go back in time for a period
                                    # longer than a day
    end
    return DateTime.new(year, month, day, hour - other.value, min, sec)
  end
end

class Time
  # Converts self to a DateTime object.
  def to_datetime
    seconds = sec + Rational(usec, 10**6)
    offset = Rational(utc_offset, 60 * 60 * 24)
    DateTime.new(year, month, day, hour, min, seconds, offset)
  end
end

class Fixnum
  # Syntactic sugar for doing something like:
  #     DateTime.new + 5.hours
   def hours
     Hours.new(self)
   end
  alias_method :hour, :hours
end
