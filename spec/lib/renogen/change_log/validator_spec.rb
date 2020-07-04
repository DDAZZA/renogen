# frozen_string_literal: true

require 'spec_helper'

describe Renogen::ChangeLog::Validator do
  let(:change_log) { Renogen::ChangeLog::Model.new }
  let(:validations) { { 'foo' => %w(bar baz) } }

  subject { described_class.new(double('Formatter', options: { 'allowed_values' => validations })) }

  before(:each) { change_log.add_change(Renogen::ChangeLog::Item.new(1, 'foo', 'bar')) }

  describe '#validate!' do
    context 'when no validations are available' do
      let(:validations) { nil }

      it 'successfully passes the validation process' do
        expect { subject.validate!(change_log) }.to_not raise_error
        subject.validate!(change_log)
      end
    end

    context 'when validation is successful' do
      it 'successfully passes the validation process' do
        expect { subject.validate!(change_log) }.to_not raise_error
        subject.validate!(change_log)
      end
    end

    context 'when validation has failed' do
      let(:validations) { { 'foo' => ['baz'] } }

      it 'fails validation' do
        expect { subject.validate!(change_log) }.to raise_error(Renogen::Exceptions::InvalidItemFound)
      end
    end
  end
end
