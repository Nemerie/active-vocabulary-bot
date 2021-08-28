require "minitest/autorun"
require_relative "../bot/process_text"


class TestBot < Minitest::Test
  def setup
    @macabre = <<~HEREDOC
      *Macabre*
      [məˈkɑːbr(ə)]

      _Adjective_
      Disturbing because concerned with or causing a fear of death.
      _Synonyms_: gruesome, grisly, grim, gory, morbid, ghastly, unearthly, lurid.
    HEREDOC

    @negus = <<~HEREDOC
      1. *Negus*
      [ˈniːɡəs]

      _Noun_
      A hot drink of port, sugar, lemon, and spice.

      2. *Negus*
      [ˈniːɡəs]

      _Noun_
      A ruler, or the supreme ruler, of Ethiopia.
    HEREDOC
  end

  def test_normal_word
	assert_equal process_text("macabre"), @macabre
	assert_equal process_text("negus"), @negus
  end

  def test_normal_sentence
    sentence = "I can't believe the story you're telling me. It's *macabre*!"
    assert_equal process_text(sentence), "#{sentence}\n#{@macabre}"

    sentence = "The *negus* ruled Ethiopia until the coup of 1974"
    assert_equal process_text(sentence), "#{sentence}\n#{@negus}"
  end

  def test_wrong_word
    assert_equal process_text("zxczxc"), "Couldn't find the meaning of the word."
  end
end
