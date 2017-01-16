# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources::Type do
  subject { described_class }

  describe 'class' do
    describe 'behavior' do
      describe '#document_class' do
        subject { super().document_class }
        it { is_expected.to be(Elasticsearch::Resources::Document) }
      end

      describe '#define_document_class' do
        subject { super().send(:define_document_class, document_class) }
        after(:each) { described_class.send(:define_document_class, Elasticsearch::Resources::Document) }

        let(:document_class) { stub_const 'TestDocumentClass', Class.new }
        it { is_expected.to be(document_class) }
        it do
          expect { subject }
            .to change { described_class.document_class }
            .from(Elasticsearch::Resources::Document)
            .to(document_class)
        end
      end
    end
  end

  describe 'instance' do
    subject { instance }

    let(:instance) { described_class.new(index: index, &block) }
    let(:block) { Proc.new { } }
    let(:client) { instance_double(Elasticsearch::Transport::Client) }
    let(:index) { instance_double(Elasticsearch::Resources::Index, name: index_name, client: client, settings: index_settings) }
    let(:index_name) { 'test_index' }
    let(:index_settings) { instance_double(Elasticsearch::Resources::Configuration::Index, type: nil) }
    let(:name) { 'test_type' }

    before(:each) { allow(instance.settings).to receive(:name).and_return(name) }
    before(:each) { allow(index_settings).to receive(:type).and_return(nil) }

    describe 'behavior' do
      describe '#initialize' do
        context 'returns an Type with' do
          describe '#index' do
            subject { super().index }
            it { is_expected.to be(index) }
          end
        end
      end

      describe '#client' do
        subject { super().client }
        it { is_expected.to be(client) }
      end

      describe '#name' do
        subject { super().name }
        before(:each) { expect(instance.settings).to receive(:name).and_return(name) }
        it { is_expected.to be(name) }
      end

      describe '#query' do
        subject { super().query(action, **options) }
        let(:action) { :get }
        let(:options) { { test: true } }
        let(:params) { { index: index_name, type: name }.merge(options) }
        let(:response) { double('response') }

        before(:each) { allow_any_instance_of(Elasticsearch::Resources::ResponseFactory).to receive(:build).and_return(response) }
        before(:each) { expect(client).to receive(action).with(**params) }

        it { is_expected.to be(response) }
      end

      describe '#search' do
        subject { super().search(body, **options) }
        let(:body) { double(Hash) }
        let(:options) { { test: true } }
        let(:result) { double('result') }
        before(:each) { expect(instance).to receive(:query).with(:search, body: body, test: true).and_return(result) }
        it { is_expected.to be(result) }
      end

      describe '#count' do
        subject { super().count(body, **options) }
        let(:body) { double(Hash) }
        let(:options) { { test: true } }
        let(:result) { double('result') }
        before(:each) { expect(instance).to receive(:query).with(:count, body: body, test: true).and_return(result) }
        it { is_expected.to be(result) }
      end

      described_class::ACTIONS.each do |action|
        describe "##{action}" do
          subject { super().send(action, **options) }
          let(:options) { { test: true } }
          let(:result) { double('result') }
          before(:each) { expect(instance).to receive(:query).with(action, test: true).and_return(result) }
          it { is_expected.to be(result) }
        end
      end

      describe '#find_index' do
        subject { super().find_index(index: index_name) }
        before(:each) { expect(index).to receive(:find_index).with(index: index_name).and_return(index) }
        it { is_expected.to be(index) }
      end

      describe '#find_type' do
        subject { super().find_type(type: type_name) }
        
        context 'when the type name' do
          context 'does not match' do
            let(:type_name) { :unknown }
            it { is_expected.to be nil }
          end

          context 'matches' do
            context 'by Symbol' do
              let(:type_name) { name.to_sym }
              it { is_expected.to be(instance) }
            end

            context 'by String' do
              let(:type_name) { name.to_s }
              it { is_expected.to be(instance) }
            end
          end
        end
      end

      describe '#document_class' do
        subject { super().document_class }
        it { is_expected.to be(Elasticsearch::Resources::Document) }
      end
    end
  end
end
