require 'spec_helper'

describe Renogen::Exceptions::ExtractionStratagyNotFound do
  let(:name) { 'foobar' }
  subject { described_class.new(name) }

  describe '#message' do
    it 'returns friendly error message' do
      expect(subject.message).to eql "Error: Unsupported source type '#{name}'"
    end

  end
end
