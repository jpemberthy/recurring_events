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

post "/register_word" do
  token = params[:text]
  category = params[:category]
  db = Corpus.new
  db.insert(token, category)
  redirect '/'
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
    "#{text_for(:salutation)} #{text_for(:name)}"
  end

  def warning_div(event)
    "<p><span class='warning'>Warning:</span> The event #{text_for(event)} was not found in the database so we're guessing.</p>"
  end

  def js_link_helper(text)
  <<-eos
<script type="text/javascript">
$(document).ready(function() {
    $('#hidden_div').before('<a href=\"#\" id=\"toggle_link\" class="warning">More information</a>');
    $('#hidden_div').hide();
    $('a#toggle_link').click(function() {
        $('#hidden_div').toggle('normal');
        return false;
    });
});
</script>
eos
  end

  def category_link(text)
    <<-eos
    <form action="/register_word" method="POST">
      <input type="hidden" name="text" value="#{ @result[:event] }">
      <input type="hidden" name="category" value="#{text.downcase.to_sym}">
      <a href="#" onclick="parentNode.submit(); return false;">#{text}</a>
     </form>
    eos
  end
end
