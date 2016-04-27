require 'spec_helper'

describe Renogen::ChangeLog::Model do
  let(:change_item) { Renogen::ChangeLog::Item.new('foo', 'bar') }

  describe '#groups' do
    it 'returns an empty hash when no changes' do
      expect(subject.groups).to eql Hash.new
    end

    it 'returns hash of changes by group_name' do
      subject.add_change(change_item)
      expect(subject.groups).to eql(change_item.group_name => [change_item])
    end
  end

  describe '#header' do
    it 'returns version and date' do
      subject.version = '123'
      expect(subject.header).to eql "123 (#{Date.today})"
    end
  end

  describe '#add_change' do
    it 'adds change to changes store' do
      subject.add_change(change_item)
      expect(subject.items.first).to eql change_item
      expect(subject.items.size).to eql 1
    end

    it 'raises error when non valid change is added' do
      expect { subject.add_change('bar') }.to raise_error TypeError
    end
  end
end
