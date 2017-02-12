require 'spec_helper'

RSpec.describe Renogen::Rules::Group do
  describe '.validator_for' do
    subject { described_class.validator_for(group_name) }

    let(:group_name) { 'Foo' }

    before do
      allow(Renogen::Config.instance).to receive(:group_rules).and_return(group_rules)
    end

    context 'when there is neither a specific nor a general group rule' do
      let(:group_rules) { {} }

      it { is_expected.to be_nil }
    end

    context 'when there is a general group rule' do
      let(:group_rules) { { '*': general_rule } }

      let(:general_rule) { double('GeneralRule') }

      context 'and when there is no specific group rule' do
        it { is_expected.to eql general_rule }
      end

      context 'and when there is a specific group rule' do
        let(:group_rules) { { 'Foo' => specific_rule, :'*' => general_rule } }

        let(:specific_rule) { double('SpecificRule') }

        it { is_expected.to eql specific_rule }
      end
    end
  end
end
