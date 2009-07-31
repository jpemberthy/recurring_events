class PhraseSet
  
  PHRASES = [{'0' => %w{what menu today}}, {'1' => %w{when next party}}, {'2' => %w{what dinner today}}]

  
  def self.message_for(phrase)
    answer =  case phrase
              when '0'
                "chineese food"
              when '1'
                "next friday"
              when '2'
                "salmon"
              end
    answer || "Kacatua doesn't know the answer!!"
  end
  
end