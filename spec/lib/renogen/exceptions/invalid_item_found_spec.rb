# frozen_string_literal: true

require 'spec_helper'

describe Renogen::Exceptions::InvalidItemFound do
  let(:invalid_items) do
    [
      {
        group_name: 'Product',
        invalid_value: 'Foo',
        valid_values: %w(Bar Baz)
      },
      {
        group_name: 'Country',
        invalid_value: 'LL',
        valid_values: %w(UK IE)
      }
    ]
  end

  subject { described_class.new(invalid_items) }

  describe '#message' do
    let(:expected_error) do
      "Invalid items:
Group: Product, Content: Foo, Valid Value: [\"Bar\", \"Baz\"]
Group: Country, Content: LL, Valid Value: [\"UK\", \"IE\"]"
    end

    it 'returns a user friendly error message' do
      expect(subject.message).to eql expected_error
    end
  end
end
