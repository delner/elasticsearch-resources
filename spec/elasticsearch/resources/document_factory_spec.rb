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
    let(:instance) { described_class.new(content: content, resources: resources) }
    let(:content) { { '_index' => index_name, '_type' => type_name, '_id' => id, '_source' => source } }
    let(:index_name) { 'test_index' }
    let(:type_name) { 'test_type' }
    let(:id) { 'test_id' }
    let(:source) { { title: 'test' } }
    let(:resources) { { } }

    describe 'behavior' do
      describe '#initialize' do
        context 'returns an ResponseFactory with' do
          describe '#content' do
            subject { super().content }
            it { is_expected.to eq(content) }
          end

          describe '#resources' do
            subject { super().resources }
            it { is_expected.to eq(resources) }
          end
        end
      end

      describe '#content' do
        it { is_expected.to respond_to(:content) }
      end

      describe '#type' do
        subject { super().resources }
        it { is_expected.to be_a_kind_of(Hash) }
      end

      describe '#build' do
        subject { super().build }

        context 'when the content' do
          context 'is missing' do
            let(:content) { super().reject { |k,v| k == missing_value } }

            context 'index' do
              let(:missing_value) { '_index' }
              it { expect { subject }.to raise_error(Elasticsearch::Resources::Configuration::Index::NullNameError) }
            end

            context 'type' do
              let(:missing_value) { '_type' }
              it { expect { subject }.to raise_error(Elasticsearch::Resources::Configuration::Type::NullNameError) }
            end

            context 'id' do
              let(:missing_value) { '_id' }
              it { expect { subject }.to raise_error(Elasticsearch::Resources::Identifiable::NullIdError) }
            end
          end

          context 'is well formed' do
            context 'and no resources are provided' do
              context 'then it returns a document with' do
                it { is_expected.to be_a_kind_of(Elasticsearch::Resources::Document) }

                context '#type' do
                  subject { super().type }
                  it { is_expected.to be_a_kind_of(Elasticsearch::Resources::Type) }
                  it { expect(subject.name).to eq(type_name) }
                end

                context '#index' do
                  subject { super().index }
                  it { is_expected.to be_a_kind_of(Elasticsearch::Resources::Index) }
                  it { expect(subject.name).to eq(index_name) }
                end

                context '#cluster' do
                  subject { super().cluster }
                  it { is_expected.to be_a_kind_of(Elasticsearch::Resources::Cluster) }
                end
              end
            end

            context 'and all resources are provided' do
              let(:resources) { { cluster: cluster, index: index, type: type } }
              let(:cluster) { instance_double(Elasticsearch::Resources::Cluster) }
              let(:index) { instance_double(Elasticsearch::Resources::Index, cluster: cluster) }
              let(:type) { instance_double(Elasticsearch::Resources::Type, index: index, document_class: Elasticsearch::Resources::Document) }

              before(:each) do
                expect(type.document_class).to receive(:new)
                  .with(type: type, id: id, attributes: source)
                  .and_call_original
              end

              context 'then it returns a document with' do
                it { is_expected.to be_a_kind_of(Elasticsearch::Resources::Document) }

                context '#type' do
                  subject { super().type }
                  it { is_expected.to be(type) }
                end

                context '#index' do
                  subject { super().index }
                  it { is_expected.to be(index) }
                end

                context '#cluster' do
                  subject { super().cluster }
                  it { is_expected.to be(cluster) }
                end
              end
            end
          end
        end
      end
    end
  end
end
