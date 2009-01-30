# -*- coding: utf-8 -*-
class EventParser
  attr_reader :text
  attr_reader :language

  def initialize(text)
    @text = text
    guess_language
    normalize_text
  end

  def self.parse(text)
    self.new(text).parse
  end

  def parse
    
  end


  protected

  # Replaces capital letters, word numbers, daytime words, ordinal words and
  # other unwanted characters in the input text string.
  def normalize_text #:nodoc:
    downcase
    numerize
    replace_daytimes
    strip_punctuation
  end

  # Remove capital letters from the input text.
  def downcase #:nodoc:
    @text.downcase!
  end

  # Replace number words with real numbers!™.
  # TODO Generalize for other languages
  def numerize #:nodoc:
    @text = Numerizer.numerize(@text)
  end

  # Replace times of the day with predefined hours.
  # TODO Generalize for other languages
  def replace_daytimes #:nodoc:
    @text.gsub!(/\bmorning/, '7:00')
    @text.gsub!(/\bnoon/, '12:00')
    @text.gsub!(/\bafternoon/, '14:00')
    @text.gsub!(/\bnight/, '20:00')
  end

  # Remove the punctuation in the original text.
  def strip_punctuation #:nodoc:
    # insert a whitespace if there's not one between the symbol and the
    # next character
    @text.gsub!(/[.,;']([ ])?/, $1 || ' ')   
    @text.rstrip!
  end
  
  # Try to guess the language used in the text. Defaults to english.
  def guess_language  #:nodoc:
    @language = :english

    languages = { 
      :spanish => /\b([Ss]ra?|esto|es|español|el|la)\b/,
      :dutch => /\b([Dd]hr|[Mm]evr|heeft|elke|minuten)\b/
    }

    languages.each do |lang, regex| 
      @language = lang if regex.match(@text)
    end
  end
end
