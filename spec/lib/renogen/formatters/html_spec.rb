require 'spec_helper'

describe Renogen::Formatters::Html do

  it 'is registered' do
    expect(Renogen::Formatters.obtain(:html)).to be_kind_of described_class
  end

  describe '#write_header' do
    it 'returns header with newline' do
      expect(subject.write_header('header')).to eql "<html>\n<h1>header</h1>"
    end
  end

  describe '#write_group' do
    it 'returns group' do
      expect(subject.write_group('group')).to eql "<h2>group</h2>\n<ul>"
    end
  end

  describe '#write_group_end' do
    it 'returns closing list tag' do
      expect(subject.write_group_end).to eql "</ul>"
    end
  end

  describe '#write_change' do
    it 'returns change with newline and hyphen' do
      expect(subject.write_change('change')).to eql "  <li>change</li>"
    end
  end

  describe '#write_footer' do
    it 'returns closing html tag' do
      expect(subject.write_footer('change')).to eql '</html>'
    end
  end
end
