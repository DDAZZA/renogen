# frozen_string_literal: true

require 'spec_helper'

describe Renogen::Config do
  subject { described_class.instance }

  describe '#configure' do
    before :each do
      described_class.configure do |config|
        config.single_line_format = 'bar'
        config.validations = ['test']
      end
    end

    it 'can set value' do
      expect(subject.single_line_format).to eql 'bar'
    end

    it 'sets the validations value' do
      expect(subject.validations).to eql ['test']
    end
  end
end
