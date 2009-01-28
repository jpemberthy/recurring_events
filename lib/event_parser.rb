class EventParser
  def initialize(text)
  end

  def self.parse(text)
    self.new(text)
  end

  def subject
  end

  def hour
  end

  def day
  end
  alias_method :days, :day

  def month
  end

  def year
  end

  def length
  end

  def recurrency
  end

  def event_type
  end
end
