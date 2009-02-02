$:.unshift File.dirname(__FILE__)    

require 'recurring_events/event'
require 'recurring_events/event_parser'
require 'recurring_events/numerizer'

require 'treetop'
require 'recurring_events/parser/parser_english'
Treetop.load File.dirname(__FILE__) + "/recurring_events/parser/parser_english"
#require 'recurring_events/parser/parser_english_definitions'


