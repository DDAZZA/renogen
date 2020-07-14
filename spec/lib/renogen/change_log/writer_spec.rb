# frozen_string_literal: true

require 'spec_helper'

describe Renogen::ChangeLog::Writer do
  describe '#write!' do
    shared_examples 'a valid output format' do
      let(:changelog) do
        Renogen::ChangeLog::Model.new(
          version: 'test',
          date: Date.new(2020, 7, 8)
        )
      end

      let(:changes) do
        [
          renogen_change(1, 'Group 1', 'This is a Group 1 change'),
          renogen_change(1, 'Group 2', 'This is a Group 2 change')
        ]
      end

      subject { Renogen::ChangeLog::Writer.new(formatter) }

      before do
        changes.each { |c| changelog.add_change(c) }
        $stdout = StringIO.new
      end

      after do
        $stdout = STDOUT
      end

      it 'writes all lines' do
        subject.write!(changelog)
        $stdout.rewind
        expected_output.split("\n").each do |line|
          expect($stdout.gets.strip).to eq(line)
        end

        # read remaining output and check we reached the end
        expect($stdout.read.gsub("\n", '')).to be_empty
      end
    end

    context 'when formatter is CSV' do
      let(:formatter) { Renogen::Formatters::Csv.new }
      let(:expected_output) do
        <<~EOS
          Group 1,Group 2
          This is a Group 1 change,This is a Group 2 change
        EOS
      end

      it_behaves_like 'a valid output format'

      context 'when changes contain commas' do
        it_behaves_like 'a valid output format' do
          let(:changes) do
            [
              renogen_change(1, 'Group 1', 'This,is,a,Group 1,change'),
              renogen_change(1, 'Group 2', 'This is a Group 2 change')
            ]
          end

          let(:expected_output) do
            <<~EOS
              Group 1,Group 2
              "This,is,a,Group 1,change",This is a Group 2 change
            EOS
          end
        end
      end
    end

    context 'when formatter is HTML' do
      let(:formatter) { Renogen::Formatters::Html.new }
      let(:expected_output) do
        <<~EOS
          <html>
          <h1>test (2020-07-08)</h1>
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

      it_behaves_like 'a valid output format'
    end

    context 'when formatter is Markdown' do
      let(:formatter) { Renogen::Formatters::Markdown.new }
      let(:expected_output) do
        <<~EOS
          # test (2020-07-08)

          ## Group 1

          * This is a Group 1 change

          ## Group 2

          * This is a Group 2 change
        EOS
      end

      it_behaves_like 'a valid output format'
    end

    context 'when formatter is MarkdownTable' do
      let(:formatter) { Renogen::Formatters::MarkdownTable.new }

      let(:expected_output) do
        <<~EOS
          # test (2020-07-08)

          | Group 1 | Group 2 |
          | - | - |
          | This is a Group 1 change<br> | This is a Group 2 change<br> |
        EOS
      end

      it_behaves_like 'a valid output format'
    end

    context 'when formatter is PlainText' do
      let(:formatter) { Renogen::Formatters::PlainText.new }
      let(:expected_output) do
        <<~EOS
          test (2020-07-08)

          Group 1
          - This is a Group 1 change

          Group 2
          - This is a Group 2 change
        EOS
      end

      it_behaves_like 'a valid output format'
    end

    describe 'duplicates' do
      let(:formatter) { Renogen::Formatters::PlainText.new }
      let(:changes_with_duplicates) do
        [
          renogen_change(1, 'Group 1', 'This is a Group 1 change'),
          renogen_change(1, 'Group 2', 'This is a Group 2 change'),
          renogen_change(2, 'Group 1', 'This is a Group 1 change'),
          renogen_change(2, 'Group 2', 'This is a Group 2 change')
        ]
      end

      context 'when remove duplicates is false in config (default)' do
        it_behaves_like 'a valid output format' do
          let(:changes) { changes_with_duplicates }

          let(:expected_output) do
            <<~EOS
              test (2020-07-08)

              Group 1
              - This is a Group 1 change
              - This is a Group 1 change

              Group 2
              - This is a Group 2 change
              - This is a Group 2 change
            EOS
          end
        end
      end

      context 'when remove duplicates is true in config' do
        before do
          allow(Renogen::Config.instance)
            .to receive(:remove_duplicates).and_return(true)
        end

        it_behaves_like 'a valid output format' do
          let(:changes) { changes_with_duplicates }

          let(:expected_output) do
            <<~EOS
              test (2020-07-08)

              Group 1
              - This is a Group 1 change

              Group 2
              - This is a Group 2 change
            EOS
          end
        end
      end
    end
  end
end
