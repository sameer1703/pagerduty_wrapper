module PagerdutyWrapper
  class Configuration
    attr_accessor :enable,
                  :service_integration_key,
                  :service,
                  :environment,
                  :logger

    def initialize
      @enable = false
      @environment = ENV['RAILS_ENV'] || 'production'
      @logger = nil
    end
  end
end
