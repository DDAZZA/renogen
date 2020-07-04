require 'spec_helper'

describe Renogen::Formatters::Base do
  let(:version) { '1.2.34' }
  let(:date) { Date.today }
  let(:changelog) { double(Renogen::ChangeLog::Model, version: version, date: date) }

  describe '#header' do
    subject { described_class.new.header(changelog) }

    it { is_expected.to eql "#{version} (#{date})" }
  end

  describe '#write_header' do
    it 'does nothing' do
      expect(subject.write_header(changelog)).to be_nil
    end
  end

  describe '#write_group' do
    it 'does nothing' do
      expect(subject.write_group(changelog)).to be_nil
    end
  end

  describe '#write_change' do
    it 'raises an NotImplementedError' do
      expect{subject.write_change('change')}.to raise_error NotImplementedError
    end
  end
end
