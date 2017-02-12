require 'spec_helper'

describe Renogen::ExtractionStratagies::YamlFile::Parser do
  let(:file_contents) { { 'Foo' => 'Bar' }  }
  let(:file_name) { 'some/file.yml' }

  describe '#parse!' do
    before :each do
      yaml_file_reader = double(Renogen::ExtractionStratagies::YamlFile::Reader)
      allow(yaml_file_reader).to receive(:each_yaml_file).and_yield(file_contents, file_name)

      allow(Renogen::ExtractionStratagies::YamlFile::Reader).to receive(:new).and_return(yaml_file_reader)

      allow(Renogen::Rules::File).to receive(:validate!)
    end

    it 'extracts contents from file' do
      changelog_item = Renogen::ChangeLog::Item.new('Foo', 'Bar')
      allow(Renogen::ChangeLog::Item).to receive(:new).with('Foo', 'Bar').and_return changelog_item

      changelog = subject.parse!

      expect(changelog.items).to include changelog_item
      expect(changelog.items.size).to eql 1
    end

    it 'validates the file contents' do
      expect(Renogen::Rules::File).to receive(:validate!).with(file_name, file_contents)

      subject.parse!
    end
  end

  describe '#config' do
    specify { expect(subject.__send__(:config)).to eql Renogen::Config.instance }
  end
end
