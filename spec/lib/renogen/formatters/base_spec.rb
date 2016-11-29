require 'spec_helper'

describe Renogen::Formatters::Base do
  describe '#header' do
    subject { described_class.new.header(changelog) }

    let(:version) { '1.2.34' }
    let(:date) { Date.today }
    let(:changelog) { double(Renogen::ChangeLog::Model, version: version, date: date) }

    it { is_expected.to eql "#{version} (#{date})" }
  end

  describe '#write_header' do
    it 'raises an NotImplementedError' do
      expect{subject.write_header('header')}.to raise_error NotImplementedError
    end
  end

  describe '#write_group' do
    it 'raises an NotImplementedError' do
      expect{subject.write_group('group_name')}.to raise_error NotImplementedError
    end
  end

  describe '#write_change' do
    it 'raises an NotImplementedError' do
      expect{subject.write_change('change')}.to raise_error NotImplementedError
    end
  end
end
