require 'spec_helper'

RSpec.describe Renogen::Rules::Validators::Array do
  specify { expect(Renogen::Rules::Validators.registered_validators).to include described_class }

  describe '.handles?' do
    subject { described_class.handles?(config) }

    context 'when the config has not "type" => "Array"' do
      let(:config) { {} }

      it { is_expected.to be false }
    end

    context 'when the config has "type" => "Array"' do
      let(:config) { { 'type' => 'Array' } }

      it { is_expected.to be true }
    end
  end

  subject { array_validator }

  let(:array_validator) { described_class.new(name, config) }

  let(:name) { 'Foo' }
  let(:config) { { 'type' => 'Array' } }

  it { is_expected.to be_a Renogen::Rules::Validators::Base }

  describe '#validate_items?' do
    subject { array_validator.validate_items? }

    context 'when there is no "items" key in the config' do
      it { is_expected.to be false }
    end

    context 'when there is a "items" key in the config' do
      let(:config) { { 'type' => 'Array', 'items' => {} } }

      it { is_expected.to be true }
    end
  end

  describe '#validate' do
    subject { array_validator.validate(contents) }

    context 'when the given contents have the wrong type' do
      let(:contents) { 'Some String that is not expected' }

      specify { expect(subject.size).to eq 1 }
      specify { expect(subject.first.message).to eq "Expected 'Foo' to be a Array, but found a String" }
    end

    context 'when the given contents have the correct type' do
      let(:contents) { ['first item', 'second item'] }

      context 'when there are no rules for the items' do
        it { is_expected.to eql [] }
      end

      context 'when there are rules for the items' do
        let(:config) { { 'type' => 'Array', 'items' => item_rules } }

        context 'and when the contents do not adhere to those rules' do
          let(:item_rules) { { 'type' => 'Hash' } }

          specify { expect(subject.size).to eq 2 }
          specify { expect(subject[0].message).to eq "Expected 'Foo' to be a Hash, but found a String" }
          specify { expect(subject[1].message).to eq "Expected 'Foo' to be a Hash, but found a String" }
        end

        context 'and when the contents adhere to those rules' do
          let(:item_rules) { { 'type' => 'String' } }

          it { is_expected.to eql [] }
        end
      end
    end
  end
end
