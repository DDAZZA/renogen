require 'spec_helper'

describe Renogen::Exceptions::YamlFileBlank do
  let(:name) { 'foobar' }
  subject { described_class.new(name) }

  describe '#message' do
    it 'returns friendly error message' do
      expect(subject.message).to eql "Error: File contents blank 'foobar'"
    end
  end
end
