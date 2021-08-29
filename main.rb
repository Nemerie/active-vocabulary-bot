require 'telegram/bot'
require_relative 'bot/request_handler'
require_relative '.config'

puts "Process ID: #{Process.pid}. Starting listening..."

start_time = Time.now.to_i

Telegram::Bot::Client.run(TOKEN) do |bot|
  begin

    bot.listen do |request|
      begin
         # Processing only messages that were sent after bot started running
         next if request.instance_variable_defined?(:@date) && start_time > request.date

        puts "Incoming request: #{request}"
        request_handler(request, bot)
      rescue Exception => e
        puts "Error during processing a request #{request}: #{e}"
      end
    end
  rescue Telegram::Bot::Exceptions::ResponseError => e
    retry if e.error_code.to_s == '502' # telegram things
  end
end
