require 'spec_helper'
require 'json'

describe Renogen::ExtractionStratagies::YamlFile::Reader do
  let(:directory_path) { './my/directory/path' }
  subject { described_class.new(directory_path) }

  describe '#each_yaml_file' do
    let(:file_contents) { { 'Foo' => 'Bar' }.to_json }

    before :each do
      allow(Dir).to receive(:glob).with([File.join(directory_path, 'next', '*.yml')]).and_return(['foo_file'])
      allow(YAML).to receive(:load_file).with('foo_file').and_return(file_contents)
    end

    it 'yields each yaml file within given directory' do
      expect { |b| subject.each_yaml_file(&b) }.to yield_with_args(file_contents)
    end
  end
end
