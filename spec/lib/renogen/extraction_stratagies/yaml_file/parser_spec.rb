require 'spec_helper'

describe Renogen::ExtractionStratagies::YamlFile::Parser do
  let(:file_contents) { { 'Foo' => 'Bar' }  }

  describe '#parse!' do
    before :each do
      yaml_file_reader = double(Renogen::ExtractionStratagies::YamlFile::Reader)
      allow(yaml_file_reader).to receive(:each_yaml_file).and_yield(file_contents, 1)
      allow(Renogen::ExtractionStratagies::YamlFile::Reader).to receive(:new).and_return(yaml_file_reader)
    end

    it 'extracts contents from file' do
      changelog_item = Renogen::ChangeLog::Item.new(1, 'Foo', 'Bar')
      allow(Renogen::ChangeLog::Item).to receive(:new).with(1, 'Foo', 'Bar').and_return changelog_item

      changelog = subject.parse!

      expect(changelog.items).to include changelog_item
      expect(changelog.items.size).to eql 1
    end
  end

end
