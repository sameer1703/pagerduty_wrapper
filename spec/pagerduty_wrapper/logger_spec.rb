require 'spec_helper'

RSpec.describe PagerdutyWrapper::Logger do
  let(:logger) { double('Logger') }
  subject { described_class.new(logger) }

  describe '#log' do
    it 'logs the using received log_level' do
      expect(logger).to receive(:warn).with('test')

      subject.log('test', :warn)
    end
  end
end
