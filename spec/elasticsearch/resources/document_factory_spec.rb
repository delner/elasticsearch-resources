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
    let(:instance) { described_class.new(type: type, content: content) }

    let(:type) { instance_double(Elasticsearch::Resources::Type, document_class: document_class) }
    let(:document_class) { double('document class') }
    let(:content) { { '_id' => id, '_source' => source } }
    let(:id) { instance_double(String) }
    let(:source) { instance_double(Hash) }

    describe 'behavior' do
      describe '#initialize' do
        context 'returns an ResponseFactory with' do
          describe '#type' do
            subject { super().type }
            it { is_expected.to eq(type) }
          end

          describe '#content' do
            subject { super().content }
            it { is_expected.to eq(content) }
          end
        end
      end

      describe '#type' do
        it { is_expected.to respond_to(:type) }
      end

      describe '#content' do
        it { is_expected.to respond_to(:content) }
      end

      describe '#build' do
        subject { super().build }
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
