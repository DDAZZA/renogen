require 'spec_helper'

RSpec.describe Renogen::Rules::Validators::Hash do
  specify { expect(Renogen::Rules::Validators.registered_validators).to include described_class }

  describe '.handles?' do
    subject { described_class.handles?(config) }

    context 'when the config has not "type" => "Hash"' do
      let(:config) { {} }

      it { is_expected.to be false }
    end

    context 'when the config has "type" => "Hash"' do
      let(:config) { { 'type' => 'Hash' } }

      it { is_expected.to be true }
    end
  end

  let(:hash_validator) { described_class.new(name, config) }
  let(:name) { 'Foo' }
  let(:config) { { 'type' => 'Hash' } }

  subject { hash_validator }

  it { is_expected.to be_a Renogen::Rules::Validators::Base }

  describe '#validate_keys?' do
    subject { hash_validator.validate_keys? }

    context 'when the config has no key "keys"' do
      it { is_expected.to be false }
    end

    context 'when the config has a key "keys"' do
      let(:config) { { 'type' => 'Hash', 'keys' => { 'required' => 'Bar' } } }

      it { is_expected.to be true }
    end
  end

  describe '#validate_items?' do
    subject { hash_validator.validate_items? }

    context 'when the config has no key "items"' do
      it { is_expected.to be false }
    end

    context 'when the config has a key "items"' do
      let(:config) { { 'type' => 'Hash', 'items' => { :'*' => { 'type' => 'String' } } } }

      it { is_expected.to be true }
    end
  end

  describe '#required_keys' do
    subject { hash_validator.required_keys }

    context 'when the config has no key "keys"' do
      it { is_expected.to eql [] }
    end

    context 'when the config has a key "keys"' do
      let(:config) { { 'type' => 'Hash', 'keys' => keys_config } }

      context 'and when the keys config has no key "required"' do
        let(:keys_config) { {} }

        it { is_expected.to eql [] }
      end

      context 'and when the keys config has a key "required"' do
        let(:keys_config) { { 'required' => required_keys } }
        let(:required_keys) { %w(Foo Bar) }

        it { is_expected.to eql required_keys }
      end
    end
  end

  describe '#optional_keys' do
    subject { hash_validator.optional_keys }

    context 'when the config has no key "keys"' do
      it { is_expected.to eql [] }
    end

    context 'when the config has a key "keys"' do
      let(:config) { { 'type' => 'Hash', 'keys' => keys_config } }

      context 'and when the keys config has no key "optional"' do
        let(:keys_config) { {} }

        it { is_expected.to eql [] }
      end

      context 'and when the keys config has a key "optional"' do
        let(:keys_config) { { 'optional' => optional_keys } }
        let(:optional_keys) { %w(Some Another) }

        it { is_expected.to eql optional_keys }
      end
    end
  end

  describe 'supported_keys' do
    subject { hash_validator.supported_keys }
    context 'when the config has no key "keys"' do
      it { is_expected.to eql [] }
    end

    context 'when the config has a key "keys"' do
      let(:config) { { 'type' => 'Hash', 'keys' => keys_config } }

      context 'and when the keys config has neither "optional" nor "required" keys' do
        let(:keys_config) { {} }

        it { is_expected.to eql [] }
      end

      context 'and when the keys config has a key "required"' do
        let(:keys_config) { { 'required' => required_keys } }
        let(:required_keys) { %w(Foo Bar) }

        it { is_expected.to eql required_keys }
      end

      context 'and when the keys config has a key "optional"' do
        let(:keys_config) { { 'optional' => optional_keys } }
        let(:optional_keys) { %w(Some Another) }

        it { is_expected.to eql optional_keys }
      end

      context 'and when the keys config has keys "required and optional"' do
        let(:keys_config) { { 'required' => required_keys, 'optional' => optional_keys } }
        let(:required_keys) { %w(Foo Bar) }
        let(:optional_keys) { %w(Some Another) }

        it { is_expected.to eql required_keys + optional_keys }
      end
    end
  end

  describe '#validate' do
    subject { hash_validator.validate(contents) }

    context 'when the contents are no Hash' do
      let(:contents) { 'Some unexpected String' }

      specify { expect(subject.size).to eq 1 }
      specify { expect(subject.first.message).to eq "Expected 'Foo' to be a Hash, but found a String" }
    end

    context 'when the contents are a Hash' do
      let(:contents) { {} }

      context 'and when there are neither rules for keys nor items' do
        it { is_expected.to eql [] }
      end

      context 'and when there are rules for the keys' do
        let(:config) { { 'type' => 'Hash', 'keys' => keys_config } }
        let(:keys_config) { { 'required' => required_keys, 'optional' => optional_keys } }
        let(:required_keys) { %w(Required) }
        let(:optional_keys) { %w(Optional) }

        context 'when the contents are missing a required key' do
          specify { expect(subject.size).to eq 1 }
          specify { expect(subject.first.message).to eq "Missing required key 'Required' for 'Foo'" }
        end

        context 'when the contents contain all required keys' do
          let(:contents) { { 'Required' => 'Foo', 'Optional' => 'Bar' } }

          it { is_expected.to eql [] }

          context 'but when there is an unexpected key' do
            let(:contents) { { 'Required' => 'Foo', 'Optional' => 'Bar', 'Unexpected' => 'Loe' } }

            specify { expect(subject.size).to eq 1 }
            specify { expect(subject.first.message).to eq "Unexpected key 'Unexpected' in 'Foo'" }
          end
        end
      end

      context 'and when there are rules for the items' do
        let(:config) { { 'type' => 'Hash', 'items' => items_config } }

        let(:items_config) { { 'Specific' => specific_config, :'*' => general_config } }
        let(:specific_config) { { 'type' => 'String' } }
        let(:general_config) { nil }

        context 'when there is no general item rule' do
          context 'but when there is no rule for any of the contents items' do
            it { is_expected.to eql [] }
          end

          context 'when there is a specific rule for an item' do
            context 'and the item adheres to that rule' do
              let(:contents) { { 'Specific' => 'Some expected String' } }

              it { is_expected.to eql [] }
            end

            context 'and the item does not adhere to that rule' do
              let(:contents) { { 'Specific' => [] } }

              specify { expect(subject.size).to eq 1 }
              specify { expect(subject.first.message).to eq "Expected 'Specific' to be a String, but found a Array" }
            end
          end
        end

        context 'when there is a general item rule' do
          let(:general_config) { { 'type' => 'String' } }

          context 'and when there is a specific rule for an item' do
            let(:specific_config) { { 'type' => 'Boolean' } }

            context 'and the item adheres to that rule' do
              let(:contents) { { 'Specific' => true } }

              it { is_expected.to eql [] }
            end

            context 'and the item does not adhere to that rule' do
              let(:contents) { { 'Specific' => [] } }

              specify { expect(subject.size).to eq 1 }
              specify { expect(subject.first.message).to eq "Expected 'Specific' to be a Boolean, but found a Array" }
            end
          end

          context 'and when there is an item without specific rule' do
            let(:contents) { { 'SomeKey' => item } }

            context 'and when it adheres to the general rule' do
              let(:item) { 'Some expected String' }

              it { is_expected.to eql [] }
            end

            context 'and when it does not adhere to the general rule' do
              let(:item) { false }

              specify { expect(subject.size).to eq 1 }
              specify { expect(subject.first.message).to eq "Expected 'SomeKey' to be a String, but found a FalseClass" }
            end
          end
        end
      end
    end
  end
end
