# frozen_string_literal: true

require 'spec_helper'

describe Renogen::Exceptions::InvalidItemFound do
  subject { described_class.new(invalid_items) }

  describe '#message' do
    context 'valid_values is an array' do
      let(:invalid_items) do
        [
          { group_name: 'Product', invalid_value: 'Foo', valid_values: %w(Bar Baz) },
          { group_name: 'Country', invalid_value: 'LL', valid_values: %w(UK IE) }
        ]
      end
      let(:expected_error) do
        "Invalid items:\nGroup: Product, Content: Foo, Valid Values: [\"Bar\", \"Baz\"]" \
        "\nGroup: Country, Content: LL, Valid Values: [\"UK\", \"IE\"]"
      end

      it 'returns a user friendly error message' do
        expect(subject.message).to eql expected_error
      end
    end

    context 'valid_values is a RegExp' do
      let(:invalid_items) { [{ group_name: 'Product', invalid_value: 'Foo', valid_values: /\b(Bar|Baz)\b/ }] }
      let(:expected_error) { "Invalid items:\nGroup: Product, Content: Foo, Pattern: #{/\b(Bar|Baz)\b/.inspect}" }

      it 'returns a user friendly error message' do
        expect(subject.message).to eql expected_error
      end
    end
  end
end
