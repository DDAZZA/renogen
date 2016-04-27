require 'spec_helper'

describe Renogen::Config do
  subject { described_class.instance }

  describe '#configure' do
    before :each do
      described_class.configure do |config|
        config.single_line_format = 'bar'
      end
    end

    it 'can set value' do
      expect(subject.single_line_format).to eql 'bar'
    end
  end
end
