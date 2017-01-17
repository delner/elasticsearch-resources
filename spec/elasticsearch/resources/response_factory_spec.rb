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
    let(:instance) { described_class.new(resource: resource, action: action, response: response) }
    let(:resource) { instance_double(Elasticsearch::Resources::Index) }
    let(:action) { instance_double(Symbol) }
    let(:response) { instance_double(Hash) }
    let(:content) { { '_index' => index_name, '_type' => type_name } }
    let(:index_name) { 'test_index' }
    let(:type_name) { 'test_type' }

    let(:document_factory) { instance_double(Elasticsearch::Resources::DocumentFactory) }
    let(:document) { instance_double(Elasticsearch::Resources::Document) }

    before(:each) { allow(document_factory).to receive(:build).and_return(document) }

    describe 'behavior' do
      describe '#initialize' do
        context 'returns an ResponseFactory with' do
          describe '#resource' do
            subject { super().resource }
            it { is_expected.to eq(resource) }
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

      describe '#resource' do
        it { is_expected.to respond_to(:resource) }
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
        let(:resources) { instance_double(Hash) }

        before(:each) { allow(instance).to receive(:resources_for).with(content).and_return(resources) }
        before(:each) do
          allow(Elasticsearch::Resources::DocumentFactory).to receive(:new)
            .with(content: content, resources: resources)
            .and_return(document_factory)
        end

        it { is_expected.to be(document) }
      end

      describe '#build_search' do
        subject { super().build_search }
        let(:response) { { 'hits' => { 'hits' => [content] } } }
        let(:resources) { instance_double(Hash) }

        before(:each) { allow(instance).to receive(:resources_for).with(content).and_return(resources) }
        before(:each) do
          allow(Elasticsearch::Resources::DocumentFactory).to receive(:new)
            .with(content: content, resources: resources)
            .and_return(document_factory)
        end

        it { is_expected.to be_a_kind_of(Array) }
        it { is_expected.to include(document) }
      end

      describe '#resources_for' do
        subject { super().resources_for(content) }
        let(:cluster) { instance_double(Elasticsearch::Resources::Cluster) }
        let(:index) { instance_double(Elasticsearch::Resources::Index) }
        let(:type) { instance_double(Elasticsearch::Resources::Type) }

        before(:each) { allow(resource).to receive(:find_cluster).and_return(cluster) }
        before(:each) { allow(resource).to receive(:find_index).with(index: index_name).and_return(index) }
        before(:each) { allow(resource).to receive(:find_type).with(index: index_name, type: type_name).and_return(type) }

        it { is_expected.to include(cluster: cluster, index: index, type: type) }
      end
    end
  end
end
