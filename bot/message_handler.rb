require_relative 'process_text'
require_relative 'commands'


def message_handler(message, bot)
  user_id = message.chat.id

  COMMANDS.each do |command, response|
    if message.text == command
      bot.api.send_message(chat_id: user_id, text: response)
    end
  end

  response = process_text(message.text)
  bot.api.send_message(chat_id: user_id, text: response, parse_mode: "Markdown")
end

