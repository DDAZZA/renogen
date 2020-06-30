# frozen_string_literal: true

require 'spec_helper'

describe Renogen::Writers do
  describe '.obtain' do
    module Renogen
      module Writers
        class RichTextWriter < Base
          register :rtf
        end
      end
    end

    module Renogen
      module Writers
        class DefaultWriter < Base
          register :default
        end
      end
    end

    context 'when a writer is registered for the given format' do
      it 'returns instance of the writer for the specified format' do
        expect(subject.obtain(:rtf, Renogen::Formatters::Base.new))
          .to be_instance_of(Renogen::Writers::RichTextWriter)
      end
    end

    context 'when a writer is not registered for the given format' do
      it 'returns instance of the default writer' do
        expect(subject.obtain(:json, Renogen::Formatters::Base.new))
          .to be_instance_of(Renogen::Writers::DefaultWriter)
      end
    end
  end
end
