require 'spec_helper'

describe Renogen::Exceptions::FormatterNotFound do
  let(:name) { 'foobar' }
  subject { described_class.new(name) }

  describe '#message' do
    it 'returns friendly error message' do
      expect(subject.message).to eql "Error: Unsupported format type '#{name}'"
    end

  end
end
