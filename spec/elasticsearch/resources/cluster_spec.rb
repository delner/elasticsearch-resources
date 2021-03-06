# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources::Cluster do
  subject { described_class }

  describe 'class' do
    describe 'behavior' do
      context 'that mutates the class' do
        subject { test_class }
        let(:test_class) { stub_const 'TestClass', Class.new(described_class) }

        describe '#define_indexes' do
          subject { super().define_indexes(**indexes) }
          let(:indexes) { { test: index } }

          context 'given a constant' do
            let(:index) { Elasticsearch::Resources::Index }
            it { is_expected.to eq({ test: index.name }) }
          end

          context 'given a string' do
            let(:index) { 'Elasticsearch::Resources::Index' }
            it { is_expected.to eq({ test: index }) }
          end
        end

        describe '#indexes' do
          subject { super().indexes }

          context 'when indexes have' do
            context 'not been defined' do
              it { is_expected.to eq({}) }
            end

            context 'been defined' do
              before(:each) { test_class.send(:define_indexes, test: 'Elasticsearch::Resources::Index') }
              it { is_expected.to eq({ test: Elasticsearch::Resources::Index }) }
            end
          end
        end
      end
    end
  end

  describe 'instance' do
    subject { instance }

    let(:instance) { described_class.new(&block) }
    let(:block) { Proc.new { } }

    describe 'behavior' do
      describe '#setup!' do
        subject { super().setup! }
        before(:each) { expect(instance.settings).to receive(:client) }
        it { is_expected.to be nil }
      end

      describe '#client' do
        subject { super().client }
        let(:client) { instance_double(Elasticsearch::Transport::Client) }
        before(:each) { expect(instance.settings).to receive(:client).and_return(client) }
        it { is_expected.to be(client) }
      end

      describe '#indexes' do
        subject { super().indexes }
        it { is_expected.to be_a_kind_of(Hash) }
        it { is_expected.to be_empty }
      end

      describe '#build_index' do
        subject { super().build_index(key: key) }
        let(:key) { :test_index }

        context 'given a key' do
          context 'that doesn\'t exist' do
            it { is_expected.to be nil }
          end

          context 'that exists' do
            let(:index_class) { class_double(Elasticsearch::Resources::Index) }
            let(:index) { instance_double(Elasticsearch::Resources::Index) }
            before(:each) { allow(instance.class).to receive(:indexes).and_return({ key => index_class }) }
            before(:each) { allow(index_class).to receive(:new).with(cluster: instance).and_return(index) }
            it { is_expected.to be(index) }
          end
        end
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

      describe '#find_cluster' do
        subject { super().find_cluster }
        it { is_expected.to be(instance) }
      end

      describe '#find_index' do
        subject { super().find_index(index: index_name) }
        let(:index_name) { :test_index }
        
        context 'when the Cluster indexes' do
          context 'do not contain a matching index' do
            it { is_expected.to be nil }
          end

          context 'contain a matching index' do
            let(:index) { instance_double(Elasticsearch::Resources::Index) }
            before(:each) { allow(instance).to receive(:indexes).and_return({ test: index }) }
            before(:each) { expect(index).to receive(:find_index).with(index: index_name).and_return(index) }
            it { is_expected.to be(index) }
          end
        end
      end

      describe '#find_type' do
        subject { super().find_type(index: index_name, type: type_name) }
        let(:index_name) { :test_index }
        let(:type_name) { :test_type }
        
        context 'when the Cluster indexes' do
          context 'do not contain a matching index' do
            it { is_expected.to be nil }
          end

          context 'contain a matching index' do
            let(:index) { instance_double(Elasticsearch::Resources::Index, name: index_name) }
            let(:type) { instance_double(Elasticsearch::Resources::Type) }
            before(:each) { allow(instance).to receive(:find_index).with(index: index_name).and_return(index) }
            before(:each) { expect(index).to receive(:find_type).with(index: index_name, type: type_name).and_return(type) }
            it { is_expected.to be(type) }
          end
        end
      end
    end
  end
end
