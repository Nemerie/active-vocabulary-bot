require 'logger'
require_relative '../.config'

class Logger
  _debug = instance_method(:debug)

  # ignore debug method in production environment
  define_method(:debug) do |str|
    _debug.bind(self).(str) if Config.env == 'debug'
  end

  def shorten(str, n)
    str.length > n ? str[..n] + '...' : str
  end
end

def initialize_logger
  file = File.new('.log', 'a')
  file.sync = true
  $log = Logger.new(file)
end
