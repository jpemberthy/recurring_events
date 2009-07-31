class PhrasesMatcher
  attr_reader :result
  
  def initialize(result)
    @result = result
  end
  
  def answer
    weights = phrases_weight
    PhraseSet.message_for(heavier_weight(weights))
  end
  
  #returns the id of the matched phrase
  def heavier_weight(weights)
    heavier_id = 0
    heavier = 0
    weights.each{|k,v| v > heavier ? (heavier_id = k; heavier = v) : "" }
    heavier_id
  end
  
  def phrases_weight
    phrases = PhraseSet::PHRASES
    matched_weights = Hash.new(0)
    @result.each{|k,v| 
      if v.class.name == "Array"
        v.collect{|token| 
          phrases.each{|phrase|
            phrase.each{|pk, pv|
              pv.collect{|keyword|
                matched_weights[pk] += 1 if /#{keyword}/ =~ token
              }
            }
          }
        }
      end 
    }
    matched_weights
  end
  
end