require 'spec_helper'

RSpec.describe Renogen::Rules::Validators::Base do
  let(:base_validator) { described_class.new(name, config) }

  let(:name) { 'Foo' }
  let(:config) { {} }

  specify { expect(base_validator.name).to eql name }
  specify { expect(base_validator.config).to eql config }

  describe '#validate_type?' do
    subject { base_validator.validate_type? }

    context 'when the config has a key "type"' do
      let(:config) { { 'type' => 'SomeType' } }

      it { is_expected.to be true }
    end

    context 'when the config has no key "type"' do
      it { is_expected.to be false }
    end
  end

  describe '#validate' do
    subject { base_validator.validate(contents) }

    let(:contents) { { 'Foo' => 'Bar' } }

    context 'when the config has no key "type"' do
      it { is_expected.to eq [] }
    end

    context 'when the config has a key "type"' do
      context 'and the actual type is the expected' do
        let(:config) { { 'type' => 'Hash' } }

        it { is_expected.to eq [] }
      end

      context 'and the actual type is not the expected' do
        let(:config) { { 'type' => 'Foobar' } }

        specify { expect(subject.size).to eq 1 }
        specify { expect(subject.first.message).to eq "Expected 'Foo' to be a Foobar, but found a Hash" }
      end
    end
  end
end
