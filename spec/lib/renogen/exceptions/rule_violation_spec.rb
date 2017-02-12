require 'spec_helper'

RSpec.describe Renogen::Exceptions::RuleViolation do
  let(:rule_violation) { described_class.new(file_path, errors) }

  let(:file_path) { 'foo/bar/abc-123.yml' }
  let(:errors) do
    [
      Renogen::Rules::Validators::ValidationError.new(message: 'foo 1', rule: nil),
      Renogen::Rules::Validators::ValidationError.new(message: 'foo 2', rule: nil)
    ]
  end

  subject { rule_violation }

  specify { expect(subject.file_path).to eql file_path }
  specify { expect(subject.errors).to eql errors }

  describe '#message' do
    subject { rule_violation.message }

    it { is_expected.to eql "In file '#{file_path}':\n" << errors.map(&:message).join("\n") }
  end
end
