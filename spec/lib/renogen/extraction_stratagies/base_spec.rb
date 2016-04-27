require 'spec_helper'

describe Renogen::ExtractionStratagies::Base do
  describe '#extract' do
    it 'raises an NotImplementedError' do
      expect { subject.extract }.to raise_error NotImplementedError
    end
  end
end
