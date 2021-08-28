require 'telegram/bot'
require_relative 'process_text'
require_relative 'commands'


def request_handler(request, bot)
  user_id = request.chat.id

  COMMANDS.each do |command, response|
    if request.text == command
      bot.api.send_message(chat_id: user_id, text: response)
    end
  end

  response = process_text(request.text)
  bot.api.send_message(chat_id: user_id, text: response, parse_mode: "Markdown")
end

