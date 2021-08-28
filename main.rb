require 'telegram/bot'
require_relative 'bot/request_handler'
require_relative 'config'

puts "Process ID: #{Process.pid}. Starting listening..."

loop do
  begin
    Telegram::Bot::Client.run(TOKEN) do |bot|
      bot.listen do |rqst|
        Thread.start(rqst) do |rqst|
          begin
            print "Incoming request: #{rqst}\n"
            request_handler(rqst, bot)
          rescue Exception => e
            print "Couldn't process a request: #{e}\n"
          end
        end
      end
    end
  rescue Exception
    print "Telegram API error\n"
  end
end
