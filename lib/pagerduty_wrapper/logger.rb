module PagerdutyWrapper
  class Logger
    extend Forwardable

    def_delegators :@logger, :debug, :info, :warn, :error, :fatal, :unknown, :log_level

    def initialize(logger)
      @logger = logger
    end

    def log(message, log_level)
      @logger.public_send(log_level, message)
    end
  end
end
