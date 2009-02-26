$:.unshift File.dirname(__FILE__)

require 'tokyocabinet'
require 'recurring_events/corpus'
require 'recurring_events/preprocessor'
require 'recurring_events/simple_matcher'
require 'recurring_events/complex_matcher'
require 'recurring_events/matchers'
require 'recurring_events/recoup'

def program_name
  $0.split('/').last
end
