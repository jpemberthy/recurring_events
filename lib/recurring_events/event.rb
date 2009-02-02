require 'date'

class Event

  attr_reader :date

  def initialize(subject, event_type, date)
    @date = date
    @subject = subject
    @type = event_type
  end

  # Returns the subject of the event.
  #
  # A subject is defined as the person who needs the service or appointment
  # when setting up an event.
  #     event.subject    # => "Mr. Johnson"
  # @return [String] The subject of the event or an empty string if no subject
  # was found.
  def subject
    @subject                    # TODO prettify output
  end

  # Returns the hour of the event in a 24-hour format.
  #     one_event.hour        # => "14:08"
  #     another_event.hour    # => "07:08"
  # @return [String] The hour of the event.
  def hour
    @date.strftime('%H:%M')
  end

  # Returns the day of the event.
  #     event.day    # => 31
  # @return [Fixnum] Day of the event.
  def day
    @date.day
  end

  # Returns the month of the event.
  #     event.month    # => 6
  # @return [Fixnum] Month of the event.
  def month
    @date.month
  end

  # Returns the year of the event.
  #     event.year    # => 2112
  # @return [Fixnum] Year of the event.
  def year
    @date.year
  end

  # Returns the length of the event. 
  #     event = EventParser.parse('Someone needs a visit for 38 minutes.')
  #     event.length    # => 38
  # @return [Fixnum] Length of the event in minutes. Defaults to 60 minutes.
  def length
    60
  end

  # Returns the date of the event.
  # @return [DateTime] Date of the event
  def date
    @date
  end

  # Returns the type of the event.
  # 
  # The type of the event is also known as the "hour type" and it represents
  # the need that the subject has.
  #     event = EventParser.parse('Someone needs a visit for 38 minutes.')
  #     event.type    => "visit"
  # @return [String] Type of the event.
  def type
    @type                       # TODO validate against known types and print.
  end
end
