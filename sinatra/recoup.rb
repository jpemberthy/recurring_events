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
  @others = @result.clone.delete_if { |k,v| [:event, :subject, :time, :recurrency, :day, :name].include?(k) }
  @to_match = parser.to_match
  haml :text
end

helpers do
  # Join all the fields with spaces and capitalize the text so it looks nice
  # on the output.
  def text_for(field)
    return(" ") if @result[field].nil?
    @result[field].join(" ").capitalize
  end

  # Salutation (if it exists) plus name (capitalized)
  def subject_name
    salutation = text_for(:salutation)
    name       = text_for(:name)
    "#{salutation} #{name}"
  end
end
