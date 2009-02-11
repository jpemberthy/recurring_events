require 'date'

class Event
  # Creates a new event.
  # 
  # If #to_datetime is defined for +start_date+/+end_date+ it'll be called to
  # make sure we're dealing with DateTime objects. 
  # 
  # <tt>other</tt> is a hash that should contain the following keys:
  # 
  # @param [String] subject The person or organization involved with the
  # event. Defaults to an empty string.
  # @param [String] event_type Type of event. A string description
  # works. Defaults to an empty string.
  # @param [DateTime] starting_date Starting date of the event. Defaults to
  # the current DateTime (DateTime.now).
  # @param [DateTime] end_date (optional) End time of the event. Expects a
  # DateTime. Defaults to +start_date+ + <tt>1 hour</tt>.
  # @raise [EventError] The +start_date+ is nil.
  def initialize(other)
    options = default_options.merge(other)

    validate_dates(options[:start_date], options[:end_date])

    @start_date = options[:start_date]
    @end_date   = options[:end_date]
    @subject    = options[:subject]
    @type       = options[:event_type]
    @recurrency = options[:recurrency]

    # Call #to_datetime in case we get Time/Date objects.
    @start_date = @start_date.to_datetime if @start_date.respond_to?(:to_datetime)
    @end_date = @end_date.to_datetime if @end_date.respond_to?(:to_datetime)

    @end_date = @start_date + 1.hour if @end_date.nil? 
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
    @start_date.strftime('%H:%M')
  end

  # Returns the day of the event.
  #     event.day    # => 31
  # @return [Fixnum] Day of the event.
  def day
    @start_date.day
  end

  # Returns the month of the event.
  #     event.month    # => 6
  # @return [Fixnum] Month of the event.
  def month
    @start_date.month
  end

  # Returns the year of the event.
  #     event.year    # => 2112
  # @return [Fixnum] Year of the event.
  def year
    @start_date.year
  end

  # Returns the length of the event. 
  #     event = EventParser.parse('Someone needs a visit for 38 minutes.')
  #     event.length    # => 38
  # 
  # Note that this length will be rounded, so 59.8 minutes will be promoted
  # to 60 minutes.
  # @return [Fixnum] Length of the event in minutes. Defaults to 60 minutes.
  def length
    @end_date - @start_date
  end

  # Returns the date of the event.
  # @return [DateTime] Date of the event
  def date
    @start_date
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

  # Returns the recurrency of the event as an offset.
  # 
  # The recurrency of the event is specified as an offset of days between
  # each time it occurs. If an event is held every week on the same day then
  # this offset will be '7'. If it happens every two weeks then it will be
  # '14' and so on.
  # @return [Fixnum] Recurrency offset in days
  def recurrency
    @recurrency
  end


  protected

  def validate_dates(start_date, end_date)            # :nodoc:
    raise EventError.new('EventError: start_date is nil') if start_date.nil?

    if end_date && (end_date < start_date)
      raise EventError.new('EventError: invalid date range')
    end
  end

  def default_options
    { 
      :start_date => DateTime.now,
      :end_date   => nil,
      :subject    => '',
      :type       => '',
      :recurrency => ''
    }
  end
    
end

  class EventError < StandardError
end
