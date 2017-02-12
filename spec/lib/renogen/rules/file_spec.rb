require 'spec_helper'

RSpec.describe Renogen::Rules::File do
  describe '.validate!' do
    subject { described_class.validate!(file_path, file_contents) }

    before do
      allow(Renogen::Config.instance).to receive(:file_rules).and_return(file_rules)
      allow(Renogen::Config.instance).to receive(:group_rules).and_return(group_rules)
    end

    let(:file_path) { 'foo/bar/123.yml' }
    let(:file_contents) { {} }

    let(:group_rules) { {} }

    context 'when there is no rule for the given file path' do
      let(:file_rules) { {} }

      specify { expect { subject }.to_not raise_error }
    end

    context 'when there is a rule for the given file path' do
      let(:file_rules) { { 'foo/**/*.yml' => foo_rules } }

      let(:foo_rules) { described_class.new('foo/**/*.yml', { 'keys' => { 'required' => ['Foo'] } }) }

      context 'when there is a root key rule that fails' do
        it 'raises a Renogen::Exceptions::RuleViolation' do
          expect { subject }.to raise_error(Renogen::Exceptions::RuleViolation) do |error|
            expect(error.file_path).to eql file_path
            expect(error.errors.size).to be 1
            expect(error.errors.first.message).to eql "Missing required key 'Foo' for ''"
          end
        end
      end

      context 'when there is a root key rule that does not fail' do
        let(:file_contents) { { 'Foo' => 'Bar' } }

        context 'when there are no group rules' do
          specify { expect { subject }.to_not raise_error }
        end

        context 'when there is a group rule' do
          let(:group_rules) { { 'Foo' => Renogen::Rules::Validators.obtain('Foo', { 'type' => 'String' }) } }

          context 'and the contents do not fit this rule' do
            let(:file_contents) { { 'Foo' => [] } }

            it 'raises a Renogen::Exceptions::RuleViolation' do
              expect { subject }.to raise_error(Renogen::Exceptions::RuleViolation) do |error|
                expect(error.file_path).to eql file_path
                expect(error.errors.size).to be 1
                expect(error.errors.first.message).to eql "Expected 'Foo' to be a String, but found a Array"
              end
            end
          end

          context 'and the contents fit this rule' do
            specify { expect { subject }.to_not raise_error }
          end
        end
      end
    end
  end

  let(:file_rule) { described_class.new(file_path_pattern, config) }

  let(:file_path_pattern) { 'foo/**/*.yml' }
  let(:config) { { 'keys' => { 'required' => ['Bar'] } } }

  specify { expect(file_rule.file_path_pattern).to eql file_path_pattern }
  specify { expect(file_rule.config).to eq config.merge('type' => 'Hash') }

  describe '#validate' do
    subject { file_rule.validate(file_contents) }

    context 'when there is a rule violation' do
      let(:file_contents) { {} }

      specify { expect(subject.size).to be 1 }
      specify { expect(subject.first.message).to eql "Missing required key 'Bar' for ''" }
    end

    context 'when there is no rule violation' do
      let(:file_contents) { { 'Bar' => 'Some String' } }

      it { is_expected.to eql [] }
    end
  end
end
