require 'telegram/bot'
require_relative 'bot/message_handler'
require_relative '.config'

puts "Process ID: #{Process.pid}. Starting listening..."

Telegram::Bot::Client.run(TOKEN) do |bot|
  begin
    start_time = Time.now.to_i

    bot.listen do |message|
      # Processing only messages that were sent after bot started running
      next if start_time > message.date

      begin
        puts "Incoming message: #{message}"
        message_handler(message, bot)
      rescue Exception => e
        puts "Error during processing a message #{message}: #{e}"
      end
    end
  rescue Telegram::Bot::Exceptions::ResponseError => e
    retry if e.error_code.to_s == '502' # telegram things
  end
end
