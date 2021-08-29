require_relative 'process_text'
require_relative 'commands'
require_relative '../models/card'

Keyboard = Telegram::Bot::Types::InlineKeyboardMarkup
Button = Telegram::Bot::Types::InlineKeyboardButton

def request_handler(request, bot)
  case request
  when Telegram::Bot::Types::CallbackQuery
    callback_handler(request, bot)
  when Telegram::Bot::Types::Message
    message_handler(request, bot)
  end
end

def callback_handler(request, bot)
  # p "req.message_id: #{request.message.message_id}"
  # p "req.message: #{request.message.text}"
  # p "request.data: #{request.data}"
  bot.api.answer_callback_query(callback_query_id: request.id, text: "Success")
end

def message_handler(message, bot)
  user_id = message.chat.id

  COMMANDS.each do |command, response|
    if message.text == command
      bot.api.send_message(chat_id: user_id, text: response)
    end
  end

  # p message.message_id

  card = process_text(message.text)

  kb = Keyboard.new(inline_keyboard: [Button.new(text: 'Save', callback_data: "save #{card.id}")])
  bot.api.send_message(chat_id: user_id, text: card.to_s, parse_mode: "Markdown", reply_markup: kb)
end
