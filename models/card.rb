require 'json'
require 'pg'
require_relative '../.config'


class Card
  attr_accessor :word, :sentence, :definition, :user_id

  def initialize
    @word = nil
    @sentence = nil
    @definition = nil
    @user_id = nil
  end

  def find
    # todo
  end

  def save
    conn = PG.connect Config.db_credentials
    conn.exec_params(
      %q{ INSERT INTO cards (definition, user_id) VALUES ($1, $2) },
      [@definition, @user_id]
    )
  end

  def to_s
    [@word, @sentence, @definition].join("\n")
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
