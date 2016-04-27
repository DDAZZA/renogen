require 'spec_helper'

describe Renogen::ChangeLog::Item do
  let(:change) { [] }
  subject { described_class.new('foo', change) }

  describe '#to_s' do
    context 'when change type is nil' do
      let(:change) { nil }
      it 'returns a blank string ' do
        expect(subject.to_s).to eql ''
      end
    end

    context "when change type is a 'String'" do
      let(:change) { "foo\nbar\n" }
      it 'returns string with newline at end' do
        expect(subject.to_s).to eql "foo\nbar\n\n"
      end
    end

    context "when change type is a 'Hash'" do
      let(:change) { Hash.new }
      it 'returns single line string' do
        config = Renogen::Config.instance
        string = config.single_line_format.downcase.gsub('\n', '\n  ')
        config.supported_keys.each do |key|
          string = string.gsub(key, '')
        end
        expect(subject.to_s).to eql string
      end
    end

    context "when change type is a 'Array'" do
      let(:change) { [] }
      it 'returns array' do
        expect(subject.to_s).to eql change
      end
    end

    context 'when change type is unknown' do
      let(:change) { described_class }
      it 'raises a type error' do
        expect { subject.to_s }.to raise_error TypeError
      end
    end
  end

  describe '#list?' do
    it 'returns true when change is an array type' do
      expect(subject.list?).to be_truthy
    end
  end

  describe '#each' do
  end
end
