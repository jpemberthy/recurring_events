class PhraseSet
  
  PHRASES = [{'0' => %w{what menu today}}, {'1' => %{when next party}}]

  
  def self.message_for(phrase)
    case phrase
    when 0
      "chineese food"
    when 1
      "next friday"
    end
  end
  
end