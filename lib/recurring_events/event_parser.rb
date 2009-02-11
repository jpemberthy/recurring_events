# -*- coding: utf-8 -*-
class EventParser
  attr_reader :text
  attr_reader :language
  attr_reader :parser

  def initialize(text=nil)
    @text = text
    guess_language
    normalize_text
  end

  # Class method to invocate the parser.
  # 
  # Equivalent to:                  
  #     EventParser.new('text').parse
  def self.parse(text)
    self.new(text).parse
  end

  # Parse the text and return a new Event.
  # 
  # Parses the text (given in the constructor or in +text+) and returns the
  # Event that was created from it. If no language is recognized then it 
  # will default the language to english. You can override this by
  # calling #language= with a symbol before the actual parsing is done, see
  # EventParser#language.
  # 
  # @param [String] text (optional) If +text+ is not nil then it will replace
  # the original text given in the initialize method.
  # @raise [ParserError] The parser was not able to correctly parse the
  # document. See error text for more information.
  def parse(text=nil)
    @text = text if !text.nil?

    @parser = RecurringEventsParser.new
    parsed_text = @parser.parse(@text)
    raise ParserError.new("Error parsing the event: parsed_text nil") if parsed_text.nil?

    result = parsed_text.value

    event_options = { }
    event_options.merge({ :subject => result[:subject] })
    event_options.merge({ :type => result[:event] })
    event_options.merge({ :start_date => parse_date(result[:time]) })
    Event.new(event_options)
  end

  # Sets the language for the parser.
  # 
  # Set the language to be used when parsing the document. I should be smart
  # enough to recognize the language you're using, but in case I'm not, you
  # can use this method to manually set the language by
  # passing a symbol for your language:
  # 
  # 
  #     EventParser.new('hola').language = :spanish
  #     EventParser.new('bye').language = :english
  # 
  # @param [Symbol] language The language to be used by the parser.
  # @raise [ParserError] The given language was not recognized.
  def language=(language)
    supported_languages = Dir.chdir(File.dirname(__FILE__) + '/parsers') { Dir['*'] }
    supported_languages.collect!{ |lang| lang.to_sym }

    if supported_languages.include?(language)
      @language = language.to_sym
    else      
      raise ParserError.new("Language #{language} is not supported")
    end
  end

  protected

  # Replaces capital letters, word numbers, daytime words, ordinal words and
  # other unwanted characters in the input text string.
  def normalize_text            # :nodoc:
    downcase
    numerize
    replace_daytimes
    strip_punctuation
  end

  # Remove capital letters from the input text.
  def downcase                  # :nodoc:
    @text.downcase!
  end

  # Replace number words with real numbers!™.
  # TODO Generalize for other languages
  def numerize                  # :nodoc:
    @text = Numerizer.numerize(@text)
  end

  # Replace times of the day with predefined hours.
  # TODO Generalize for other languages
  # TODO Too much logic in here, move some of this to the parser
  def replace_daytimes          # :nodoc:
    @text.gsub!(/\b((at|in the) )?morning/, 'at 7:00')
    @text.gsub!(/\b((at|in the) )?noon/, 'at 12:00')
    @text.gsub!(/\b((at|in the) )?afternoon/, 'at 14:00')
    @text.gsub!(/\b((at|in the) )?night/, 'at 20:00')
  end

  # Remove the punctuation in the original text.
  def strip_punctuation         # :nodoc:
    # insert a whitespace if there's not one between the symbol and the
    # next character
    @text.gsub!(/[.,;'-]([ ])?/, $1 || ' ')
    @text.gsub!(/\b(a|p) m\b/, "\\1" + 'm')    # fix the cases with a m/p m
    @text.rstrip!
  end
  
  # Try to guess the language used in the text. Defaults to english.
  def guess_language            # :nodoc:
    @language = :english

    languages = { 
      :spanish => /\b([Ss]ra?|esto|es|español|el|la)\b/,
      :dutch => /\b([Dd]hr|[Mm]evr|heeft|elke|minuten)\b/
    }

    languages.each do |lang, regex| 
      @language = lang if regex.match(@text)
    end
  end

  # Make sure we got a valid date (at least a day and an hour).
  # TODO add validation
  def parse_date(date)          # :nodoc
    date.gsub!(/\bat/, '')      # TODO fix this from inside the parser
    Chronic.parse(date) || fix_date(date)
  end
  
  def fix_date(date)            # :nodoc:
    date                        # TODO write this method.
  end
end

class ParserError < StandardError; end
