# frozen_string_literal: true

require 'spec_helper'

describe Renogen::Writers::Html do
  let(:formatter) { Renogen::Formatters::Html.new }

  subject { Renogen::Writers::Html.new(formatter) }

  describe '#write!' do
    let(:expected_output) do
      <<~EOS
        <html>
        <h1>test (2020-01-14)</h1>
        <h2>Group 1</h2>
        <ul>
        <li>This is a Group 1 change
        </li>
        </ul>
        <h2>Group 2</h2>
        <ul>
        <li>This is a Group 2 change
        </li>
        </ul>
        </html>
      EOS
    end

    let(:change_1) { renogen_change('Group 1', 'This is a Group 1 change') }
    let(:change_2) { renogen_change('Group 2', 'This is a Group 2 change') }
    let(:changelog) do
      Renogen::ChangeLog::Model.new(
        version: 'test',
        date: Date.new(2020, 1, 14)
      )
    end

    before do
      [change_1, change_2].each { |c| changelog.add_change(c) }
      $stdout = StringIO.new
    end

    after do
      $stdout = STDOUT
    end

    it 'writes all HTML lines' do
      subject.write!(changelog)
      $stdout.rewind

      expected_output.split("\n").each do |line|
        expect($stdout.gets.strip).to eq(line)
      end
    end
  end
end

