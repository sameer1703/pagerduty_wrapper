require 'pagerduty_wrapper/version'
require 'pagerduty'

# Module to report Pagerduty incident
module PagerdutyWrapper
  autoload :Configuration,    'pagerduty_wrapper/configuration'
  autoload :Logger,           'pagerduty_wrapper/logger'
  autoload :Api,              'pagerduty_wrapper/api'
  class Error < StandardError; end
  class << self
    attr_accessor :config

    def config
      @config ||= Configuration.new
    end

    def configure
      yield(config)

      config = PagerdutyWrapper.config
      raise 'service_integration_key is not configured for pageduty' if blank(config.service_integration_key)
      raise 'service is not configured for pagerduty' if blank(config.service)

      logger.log('Pagerduty is not enabled.', :warn) unless config.enable
    end

    def logger
      @logger ||= PagerdutyWrapper::Logger.new PagerdutyWrapper.config.logger
    end

    def report_incident(title, description = nil)
      raise 'empty or invalid title' if blank(title)
      config = PagerdutyWrapper.config
      if config.enable
        client.trigger(
          title,
          details: {
            Environment: config.environment,
            Service: config.service,
            Description: description
          }
        )
      end
    end

    def report_exception(exception)
      report_incident(exception.class.name, exception.message + '\n' + exception.backtrace.join("\n"))
    end

    def resolve_incident(incident_key)
      incident = client.get_incident(incident_key)
      incident.resolve
    end

    private

    def blank(obj)
      obj.nil? || obj.empty?
    end

    def client
      @client ||= Pagerduty.new PagerdutyWrapper.config.service_integration_key
    end
  end
end
