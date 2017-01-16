# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources::DocumentFactory do
  subject { described_class }

  describe 'class' do
    describe 'behavior' do
    end
  end

  describe 'instance' do
    subject { instance }
    let(:instance) { described_class.new }

    describe 'behavior' do
      describe '#build' do
        subject { super().build(type: type, document: raw_document) }
        let(:type) { instance_double(Elasticsearch::Resources::Type, document_class: document_class) }
        let(:document_class) { double('document class') }
        let(:raw_document) { { '_id' => id, '_source' => source } }
        let(:id) { instance_double(String) }
        let(:source) { instance_double(Hash) }
        let(:document) { instance_double(Elasticsearch::Resources::Document) }

        before(:each) do
          expect(document_class).to receive(:new)
            .with(type: type, id: id, attributes: source)
            .and_return(document)
        end

        it { is_expected.to be(document) }
      end
    end
  end
end
