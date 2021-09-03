require 'telegram/bot'
require_relative 'bot/request_handler'
require_relative 'bot/logger'
require_relative '.config'

initialize_logger
$log.info "Starting listening..."
$log.debug "Process ID: #{Process.pid}"

start_time = Time.now.to_i

Telegram::Bot::Client.run(Config.token) do |bot|
  begin

    bot.listen do |request|
      begin
        # Processing only messages that were sent after the bot started running
        next if request.instance_variable_defined?(:@date) && start_time > request.date

        $log.info "Incoming request: #{request}"
        request_handler(request, bot)
      rescue Exception => e
        $log.error "Error during processing a request #{request}: #{e}"
      end
    end
  rescue Telegram::Bot::Exceptions::ResponseError => e
    $log.error "Telegram exception: #{e}"
    retry if e.error_code.to_s == '502' # telegram things
  end
end
