# frozen_string_literal: true

require 'spec_helper'
require 'json'

describe Renogen::ExtractionStratagies::YamlFile::Reader do
  let(:directory_path) { './my/directory/path' }
  subject { described_class.new(directory_path) }

  describe '#each_yaml_file' do
    let(:file_contents) { { 'Foo' => 'bar' }.to_json }

    it 'yields each yaml file within given directory' do
      allow(Dir).to receive(:glob).with([File.join(directory_path, 'next', '*.yml')]).and_return(['foo_file'])
      allow(YAML).to receive(:load_file).with('foo_file').and_return(file_contents)
      expect { |b| subject.each_yaml_file(&b) }.to yield_with_args(file_contents)
    end

    it 'throws invalid yaml file when missing quotes' do
      allow(subject).to receive(:change_directories).and_return(%w(foo bar))
      foo = Psych::SyntaxError.new('a', 1, 2, 'd', 'e', 'f')
      allow(YAML).to receive(:load_file).and_raise(foo)
      expect { subject.each_yaml_file }.to raise_error(Renogen::Exceptions::YamlFileInvalid)
    end
  end
end
