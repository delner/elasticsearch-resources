# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources::ResponseFactory do
  subject { described_class }

  describe 'class' do
    describe 'behavior' do
    end
  end

  describe 'instance' do
    subject { instance }
    let(:instance) { described_class.new(context: context, action: action, response: response) }
    let(:context) { instance_double(Elasticsearch::Resources::Index) }
    let(:action) { instance_double(Symbol) }
    let(:response) { instance_double(Hash) }
    let(:content) { { '_index' => index_name, '_type' => type_name } }
    let(:index_name) { 'test_index' }
    let(:type_name) { 'test_type' }

    let(:matching_index) { instance_double(Elasticsearch::Resources::Index) }
    let(:matching_type) { instance_double(Elasticsearch::Resources::Type) }
    let(:document_factory) { instance_double(Elasticsearch::Resources::DocumentFactory) }
    let(:document) { instance_double(Elasticsearch::Resources::Document) }

    before(:each) { allow(context).to receive(:find_type).with(index: index_name, type: type_name).and_return(matching_type) }
    before(:each) { allow(document_factory).to receive(:build).and_return(document) }

    describe 'behavior' do
      describe '#initialize' do
        context 'returns an ResponseFactory with' do
          describe '#context' do
            subject { super().context }
            it { is_expected.to eq(context) }
          end

          describe '#action' do
            subject { super().action }
            it { is_expected.to eq(action) }
          end

          describe '#response' do
            subject { super().response }
            it { is_expected.to eq(response) }
          end
        end
      end

      describe '#context' do
        it { is_expected.to respond_to(:context) }
      end

      describe '#action' do
        it { is_expected.to respond_to(:action) }
      end

      describe '#response' do
        it { is_expected.to respond_to(:response) }
      end

      describe '#build' do
        subject { super().build }

        context 'given an action' do
          context '\'get\'' do
            let(:action) { :get }
            before(:each) { expect(instance).to receive(:build_get).and_return(document) }
            it { is_expected.to be(document) }
          end

          context '\'search\'' do
            let(:action) { :search }
            let(:documents) { [document] }
            before(:each) { expect(instance).to receive(:build_search).and_return(documents) }
            it { is_expected.to be(documents) }
          end

          context 'that is unknown' do
            let(:action) { :unknown }
            it { is_expected.to be(response) }
          end
        end
      end

      describe '#build_get' do
        subject { super().build_get }
        let(:response) { content }

        before(:each) do
          allow(Elasticsearch::Resources::DocumentFactory).to receive(:new)
            .with(type: matching_type, content: response)
            .and_return(document_factory)
        end

        it { is_expected.to be(document) }
      end

      describe '#build_search' do
        subject { super().build_search }
        let(:response) { { 'hits' => { 'hits' => [content] } } }

        before(:each) do
          allow(Elasticsearch::Resources::DocumentFactory).to receive(:new)
            .with(type: matching_type, content: content)
            .and_return(document_factory)
        end

        it { is_expected.to be_a_kind_of(Array) }
        it { is_expected.to include(document) }
      end

      describe '#get_document_type' do
        subject { super().get_document_type(content: content) }
        before(:each) { expect(context).to receive(:find_type).with(index: index_name, type: type_name).and_return(matching_type) }
        it { is_expected.to be(matching_type) }
      end

      describe '#get_document_type!' do
        subject { super().get_document_type!(content: content) }
        before(:each) { expect(instance).to receive(:get_document_type).with(content: content).and_return(matching_type) }

        context 'when matching_type is' do
          context 'nil' do
            let(:matching_type) { nil }
            it { expect { subject }.to raise_error(Elasticsearch::Resources::ResponseFactory::UnknownTypeError) }
          end

          context 'a Type' do
            it { is_expected.to be(matching_type) }
          end
        end
      end
    end
  end
end
