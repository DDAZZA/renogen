require 'spec_helper'

describe Renogen::Config do
  before { described_class.instance_variable_set(:@singleton__instance__, nil) }

  subject { described_class.instance }

  describe '#initialize' do
    context 'when there is a config file' do
      before do
        allow(YAML).to receive(:load_file).with('.renogen').and_return(config_file_contents)
      end

      let(:config_file_contents) { YAML.load(<<-YAML) }
changelog_path: './changelog/'
single_line_format: 'heading (uri)'
supported_keys:
- heading
- uri
input_source: 'yaml'
output_format: 'markdown'
default_headings:
- Task
- Bug
file_rules:
  "**/*.yml":
    keys:
      required:
      - Summary
      optional:
      - Details
      - Tasks
group_rules:
  Summary:
    type: Hash
    keys:
      required:
      - link
      - summary
      optional:
      - identifier
    items:
      identifier:
        type: String
      link:
        type: String
      summary:
        type: String
  Details:
    type: String
  Tasks:
    type: Array
    items:
      type: String
      YAML

      its(:single_line_format) { is_expected.to eql 'heading (uri)' }
      its(:supported_keys) { is_expected.to eql %w(heading uri) }
      its(:input_source) { is_expected.to eql 'yaml' }
      its(:output_format) { is_expected.to eql 'markdown' }
      its(:changelog_path) { is_expected.to eql './changelog/' }
      its(:default_headings) { is_expected.to eql %w(Task Bug) }

      it 'parses and sets the file rules' do
        expect(subject.file_rules).
          to eq('**/*.yml' => Renogen::Rules::File.new('**/*.yml', config_file_contents.dig('file_rules', '**/*.yml')))
      end

      it 'parses and sets the group rules' do
        expect(subject.group_rules).
          to eq(
            'Summary' => Renogen::Rules::Validators.obtain(
              'Summary', config_file_contents.dig('group_rules', 'Summary')),
            'Details' => Renogen::Rules::Validators.obtain(
              'Details', config_file_contents.dig('group_rules', 'Details')),
            'Tasks' => Renogen::Rules::Validators.obtain(
              'Tasks', config_file_contents.dig('group_rules', 'Tasks')))
      end
    end

    context 'when there is no config file' do
      before do
        allow(YAML).to receive(:load_file).with('.renogen').and_raise(Errno::ENOENT)
      end

      its(:single_line_format) { is_expected.to eql 'summary (see link)' }
      its(:supported_keys) { is_expected.to eql %w(identifier link summary) }
      its(:input_source) { is_expected.to eql 'yaml' }
      its(:output_format) { is_expected.to eql 'markdown' }
      its(:changelog_path) { is_expected.to eql './change_log' }
      its(:default_headings) { is_expected.to eql %w(Summary Detailed Tasks) }
      its(:file_rules) { is_expected.to eql({}) }
      its(:group_rules) { is_expected.to eql({}) }
    end
  end

  describe '#configure' do
    before :each do
      described_class.configure do |config|
        config.single_line_format = 'bar'
      end
    end

    it 'can set value' do
      expect(subject.single_line_format).to eql 'bar'
    end
  end

  describe '#supported_keys_for' do
    subject { described_class.instance.supported_keys_for(group_name) }

    let(:group_name) { 'Foo' }

    context 'when there is no rule for the given group name' do
      it { is_expected.to eql described_class.instance.supported_keys }
    end

    context 'when there is a group rule for the given name' do
      before do
        described_class.instance.group_rules[group_name] = Renogen::Rules::Validators.obtain(
          group_name,
          {
            'type' => 'Hash',
            'keys' => {
              'required' => %w(title),
              'optional' => %w(uri description)
            }
          })
      end

      it { is_expected.to eql %w(title uri description) }
    end
  end

end
