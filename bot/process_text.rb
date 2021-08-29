require 'net/http'
require 'json'
require_relative '../models/card'


class String
  def upcase_first_letter
    self[0] = self[0].upcase
    self
  end

  def string_between_markers marker1, marker2
    self[/#{Regexp.escape(marker1)}(.*?)#{Regexp.escape(marker2)}/m, 1]
  end
end

class Array
  def to_s_with_indices(delimeter)
    return "" if self.length == 0
    return self[0] if self.length == 1

    self.map.with_index do |elem, i|
      (i + 1).to_s + delimeter + ' ' + elem
    end.join("\n")
  end
end

def process_text(text)
  word = text.include?("*") ? text.string_between_markers("*", "*") : text

  card = Card.new
  
  if word.nil?
    card.definition = "Couldn't process the sentence. Type /help to see examples of usage."

    return card
  end

  card.word = word
  card.definition = get_definition(word)

  if text != word
    card.sentence = text
  end
  
  card
end

def get_definition(word)
  word.gsub! " ", "%20" # API allows to look up multiple words 

  uri = 'https://api.dictionaryapi.dev/api/v2/entries/en/' + word
  json = JSON.parse(Net::HTTP.get(URI.parse(uri)))

  return "Couldn't find the meaning of the word." unless json.kind_of?(Array)

  json.map.with_index do |word, i|
    spelling = "*#{word['word'].capitalize}*"
    phonetic = "[#{word['phonetic']}]"
  
    meanings = word['meanings'].map do |parts|
      part = parts['partOfSpeech'].capitalize
      part_list = parts['definitions'].map do |definitions|
        definition = definitions['definition'].upcase_first_letter
        synonyms = !definitions['synonyms'].empty? ? "_Synonyms_: #{definitions['synonyms'][0..7].join(', ')}.\n" : ""
        antonyms = !definitions['antonyms'].empty? ? "_Antonyms_: #{definitions['antonyms'].join(', ')}.\n" : ""
  
        "#{definition}\n#{synonyms}#{antonyms}"
      end.to_s_with_indices(')')
  
      "_#{part}_\n#{part_list}"
    end.join("\n")

    "#{spelling}\n#{phonetic}\n\n#{meanings}"
  end.to_s_with_indices('.')
end
