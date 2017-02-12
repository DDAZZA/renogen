require 'spec_helper'

RSpec.describe Renogen::Rules::Validators::Boolean do
  specify { expect(Renogen::Rules::Validators.registered_validators).to include described_class }

  describe '.handles?' do
    subject { described_class.handles?(config) }

    context 'when the config has not "type" => "Boolean"' do
      let(:config) { {} }

      it { is_expected.to be false }
    end

    context 'when the config has "type" => "Boolean"' do
      let(:config) { { 'type' => 'Boolean' } }

      it { is_expected.to be true }
    end
  end

  let(:boolean_validator) { described_class.new(name, config) }
  let(:name) { 'Foo' }
  let(:config) { { 'type' => 'Boolean' } }

  describe '#validate' do
    subject { boolean_validator.validate(contents) }

    context 'when the contents do not match the type' do
      let(:contents) { 'Some unexpected String' }

      specify { expect(subject.size).to eq 1 }
      specify { expect(subject.first.message).to eq "Expected 'Foo' to be a Boolean, but found a String" }
    end

    context 'when the contents are "true"' do
      let(:contents) { true }

      it { is_expected.to eql [] }
    end

    context 'when the contents are "false"' do
      let(:contents) { false }

      it { is_expected.to eql [] }
    end
  end
end
