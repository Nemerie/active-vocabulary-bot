require_relative 'process_text'
require_relative 'commands'
require_relative '../models/card'
require_relative 'logger'

Keyboard = Telegram::Bot::Types::InlineKeyboardMarkup
Button = Telegram::Bot::Types::InlineKeyboardButton

def request_handler(request, bot)
  case request
  when Telegram::Bot::Types::CallbackQuery
    callback_handler(request, bot)
  when Telegram::Bot::Types::Message
    message_handler(request, bot)
  else
    $log.error "Unknown type of request: #{request}"
  end
end

def callback_handler(request, bot)
  $log.debug "req.message_id: #{request.message.message_id}"
  $log.debug $log.shorten("req.message: #{request.message.text}", 5000)
  $log.debug "request.data: #{request.data}"

  case request.data
  when 'save w/ sentence'
    save_callback(request.message.text, request.message.chat.id, true)
  when 'save w/o sentence'
    save_callback(request.message.text, request.message.chat.id, false)
  end

  bot.api.answer_callback_query(callback_query_id: request.id, text: 'Success')
end

def save_callback(card, user_id, with_sentence)
  splitted = card.split("\n")

  card = Card.new
  card.word = splitted[0]
  card.sentence = with_sentence ? splitted[1] : nil
  card.definition = (with_sentence ? splitted[2..] : splitted[1..]).join("\n")
  card.user_id = user_id

  card.save
end

def message_handler(message, bot)
  user_id = message.chat.id

  COMMANDS.each do |command, response|
    if message.text == command
      bot.api.send_message(chat_id: user_id, text: response)
    end
  end

  $log.debug message.message_id

  card = process_text(message.text)

  kb = Keyboard.new(inline_keyboard: [Button.new(text: 'Save', callback_data: "save #{card.sentence.nil? ? 'w/o' : 'w/'} sentence")])
  bot.api.send_message(chat_id: user_id, text: card.to_s, parse_mode: 'Markdown', reply_markup: (card.word.nil? ? nil : kb))
end
