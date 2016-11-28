require 'spec_helper'

describe Renogen::ChangeLog::Model do
  let(:change_item) { Renogen::ChangeLog::Item.new('foo', 'bar') }

  describe '#groups' do
    it 'returns an empty hash when no changes' do
      expect(subject.groups).to eql Hash.new
    end

    it 'returns hash of changes by group_name' do
      subject.add_change(change_item)
      expect(subject.groups).to eql({change_item.group_name => [change_item]})
    end
  end

  describe '#add_change' do
    it 'adds change to changes store' do
      subject.add_change(change_item)
      expect(subject.items.first).to eql change_item
      expect(subject.items.size).to eql 1
    end

    it 'raises error when non valid change is added' do
      expect{subject.add_change('bar')}.to raise_error TypeError
    end
  end

  describe '#date' do
    it 'defaults to Date.today' do
      expect(subject.date).to eql Date.today
    end

    it 'can be set using an option' do
      date = Date.parse('2015-12-25')
      model_instance = described_class.new(date: date)

      expect(model_instance.date).to eql date
    end

    it 'has a setter' do
      date = Date.parse('1981-03-20')

      subject.date = date

      expect(subject.date).to eql date
    end
  end

end
