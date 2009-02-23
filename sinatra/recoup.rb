require 'rubygems'
require 'sinatra'
require File.join(File.dirname(__FILE__), '..', 'lib', 'recurring_events')

get '/' do
  haml :index
end

post "/text" do
  text = params[:text]
  parser = Recoup.new(text)
  @result = parser.start
  @unmatched = @result.clone.delete_if { |k,v| [:event, :subject, :time].include?(k) }
  haml :text
end


