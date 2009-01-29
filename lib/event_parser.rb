class EventParser
  attr_accessor :text

  def initialize(text)
    @text = text
  end

  def self.parse(text)
    self.new(text).parse
  end

  def parse
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

  def downcase
    
  end
end
