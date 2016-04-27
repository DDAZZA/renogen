require 'spec_helper'

describe Renogen::Formatters::PlainText do
  it "is returned for 'plain_text'" do
    expect(Renogen::Formatters.obtain(:plain_text)).to be_kind_of described_class
  end

  it "is returned for 'text'" do
    expect(Renogen::Formatters.obtain(:text)).to be_kind_of described_class
  end

  describe '#write_header' do
    it 'returns header with newline' do
      expect(subject.write_header('header')).to eql "header\n "
    end
  end

  describe '#write_group' do
    it 'returns group' do
      expect(subject.write_group('group')).to eql 'group'
    end
  end

  describe '#write_change' do
    it 'returns change with newline and hyphen' do
      expect(subject.write_change('change')).to eql '- change'
    end
  end
end
