require 'spec_helper'

describe Renogen::ChangeLog::Group do
  describe '#add' do
    subject { described_class.new('my group') }

    it 'adds change to group' do
      subject.add('foo')
      expect(subject.changes).to include('foo')
    end

  end
end
