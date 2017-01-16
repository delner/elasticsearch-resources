# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources::Document do
  subject { described_class }

  describe 'class' do
    describe 'behavior' do
    end
  end

  describe 'instance' do
    subject { instance }

    let(:instance) { described_class.new(type: type, id: id, attributes: attributes) }
    let(:type) { instance_double(Elasticsearch::Resources::Type, index: index, name: type_name, client: client) }
    let(:type_name) { 'test_type' }
    let(:index) { instance_double(Elasticsearch::Resources::Index, name: index_name) }
    let(:index_name) { 'test_index' }
    let(:client) { instance_double(Elasticsearch::Transport::Client) }
    let(:id) { 'test_id' }
    let(:attributes) { { 'test' => true } }

    describe 'behavior' do
      describe '#initialize' do
        context 'returns an Document with' do
          describe '#type' do
            subject { super().type }
            it { is_expected.to be(type) }
          end

          describe '#id' do
            subject { super().id }
            it { is_expected.to eq(id.to_s) }
          end

          describe '#attributes' do
            subject { super().attributes }
            it { is_expected.to eq(attributes) }
          end
        end
      end

      describe '#client' do
        subject { super().client }
        it { is_expected.to be(client) }
      end

      describe '#index' do
        subject { super().index }
        it { is_expected.to be(index) }
      end

      describe '#query' do
        subject { super().query(action, **options) }
        let(:action) { :get }
        let(:options) { { test: true } }
        let(:params) { { id: id, index: index_name, type: type_name }.merge(options) }
        let(:response) { double('response') }

        before(:each) { allow_any_instance_of(Elasticsearch::Resources::ResponseFactory).to receive(:build).and_return(response) }
        before(:each) { expect(client).to receive(action).with(**params) }

        it { is_expected.to be(response) }
      end

      [:create, :update].each do |action|
        describe "##{action}" do
          subject { super().send(action, **options) }
          let(:options) { { test: true } }
          let(:result) { double('result') }
          before(:each) { expect(instance).to receive(:query).with(action, test: true, body: attributes).and_return(result) }
          it { is_expected.to be(result) }
        end
      end

      [:exists?, :delete, :get].each do |action|
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
        it { is_expected.to be(index) }
      end

      describe '#find_type' do
        subject { super().find_type(index: index_name, type: type_name) }
        it { is_expected.to be(type) }
      end
    end
  end
end
