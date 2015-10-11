require 'spec_helper'

describe Renogen::Exceptions::StratagyNotFound do
  let(:name) { 'foobar' }
  subject { described_class.new(name) }

  describe '#message' do
    it 'returns friendly error message' do
      expect(subject.message).to eql "Error: Stratagy type '#{name}' not found"
    end

  end
end
