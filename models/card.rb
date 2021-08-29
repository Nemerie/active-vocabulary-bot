require 'json'

class Card
  attr_accessor :word, :sentence, :definition
  attr_reader :id

  def initialize
    @word = nil
    @sentence = nil
    @definition = nil
    @id = 1 # todo
  end

  def with_action(action)
    card = Card.new
    card.word = @word
    card.sentence = @sentence
    card.definition = @definition
    card.instance_variable_set(:@action, action)

    card
  end

  def save
    # to do: save the object in db
  end

  def to_s
    fields.values.join("\n")
  end

  def to_json
    '{' + fields.map { |k, v| "#{k}: #{v}" }.join(", ") + '}'
  end

  private
    def fields
      instance_variables.map do |iv|
        val = self.instance_variable_get(iv)
        val.nil? ? nil : { iv.to_s[1..] => val }
      end.compact.reduce({}, :merge)
    end
end
