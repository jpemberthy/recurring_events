Skynet
======

Experimental branch of the recurring events parser.

Here we use a different approach for parsing the words: Based on a corpus of
word-categories we try to filter the "useful words" from a sentence. 
For all the non-matched words, we run a series of Matchers (filters) to see
if they fit in any category. A single matcher could be:

    /\d\d(:\d\d)?/  # Dumb regexp to match hours

Or something more complex like:

    Matcher.new(/some_regex/) do |matches|
      function_transforms_the_matches
    end

With these two sets of words we try to sort out what the phrase was trying to
say.

A TokyoCabinet HDB is used as the backend for the database of words/categories. All
the non-matched results are saved in the database too so we can hopefully fix
them.
