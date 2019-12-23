RSpec.describe PagerdutyWrapper do
  let(:logger) { double('Logger') }
  it 'has a version number' do
    expect(PagerdutyWrapper::VERSION).not_to be nil
  end

  it 'should throw error for missing service_integration_key' do
    expect do
      PagerdutyWrapper.configure do |config|
        config.service = 'Store Service'
        config.service_integration_key = ''
        config.logger = nil
      end
    end
      .to raise_error('service_integration_key is not configured for pageduty')
  end

  it 'should throw error for missing service' do
    expect do
      PagerdutyWrapper.configure do |config|
        config.service_integration_key = 'rryewywyrwtyrtyreyreytr'
        config.service = ''
        config.logger = nil
      end
    end
      .to raise_error('service is not configured for pagerduty')
  end

  it 'Configure plugin without error' do
    expect(logger).to receive(:warn).with('Pagerduty is not enabled.')
    expect do
      PagerdutyWrapper.configure do |config|
        config.service_integration_key = 'rryewywyrwtyrtyreyreytr'
        config.service = 'Test Service'
        config.logger = logger
      end
    end
      .not_to raise_error
  end

  describe '#report_incident' do
    it 'throws error if title is not passed' do
      expect do
        PagerdutyWrapper.report_incident('')
      end
        .to raise_error('empty or invalid title')
    end
    it 'Creates incident' do
      PagerdutyWrapper.configure do |config|
        config.service_integration_key = 'rryewywyrwtyrtyreyreytr'
        config.service = 'Test Service'
        config.enable = true
        config.logger = logger
      end
      allow_any_instance_of(Pagerduty).to receive(:trigger).and_return('{"incident":"abcdef"}')
      expect do
        PagerdutyWrapper.report_incident('Test title')
      end
        .not_to raise_error
    end
    it 'Creates incident for exception' do
      allow_any_instance_of(Pagerduty).to receive(:trigger).and_return('{"incident":"abcdef"}')
      begin
        raise 'Error occured'
      rescue => exception
        expect do
          PagerdutyWrapper.report_exception(exception)
        end
          .not_to raise_error
      end
    end
  end
end
