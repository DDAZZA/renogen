require 'spec_helper'

RSpec.describe Renogen::Rules::Validators do
  describe '.obtain' do
    subject { described_class.obtain(name, config) }

    let(:name) { 'Some Group' }
    let(:config) { { 'type' => requested_type } }

    context 'when the requested type is registered' do
      let(:requested_type) { 'Hash' }

      it { is_expected.to be_a Renogen::Rules::Validators::Hash }

      specify { expect(subject.name).to eql name }
      specify { expect(subject.config).to eql config }
    end

    context 'when the requested type is not registered' do
      let(:requested_type) { 'Unknown' }

      before { allow($stderr).to receive(:puts) }

      it { is_expected.to be_a Renogen::Rules::Validators::Base }

      specify { expect(subject.name).to eql name }
      specify { expect(subject.config).to eql config }

      it 'prints a warning to $stderr' do
        expect($stderr).to receive(:puts).with("Using fallback validator for '#{name}'. Check 'type' config key.")

        subject
      end
    end
  end

  describe '.register' do
    subject { described_class.register(validator_class) }

    let(:validator_class) { Class.new(Renogen::Rules::Validators::Base) }

    after { described_class.registered_validators.delete(validator_class) }

    it 'adds the given class to the list of registered validators' do
      subject

      expect(described_class.registered_validators).to include validator_class
    end
  end

  describe '.registered_validators' do
    subject { described_class.registered_validators }

    it { is_expected.to eql described_class.instance_variable_get(:@registered_validators) }
  end
end
