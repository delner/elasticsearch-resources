# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources::Index do
  subject { described_class }

  describe 'class' do
    describe 'behavior' do
    end
  end

  describe 'instance' do
    subject { instance }

    let(:instance) { described_class.new(cluster: cluster, &block) }
    let(:block) { Proc.new { } }
    let(:client) { instance_double(Elasticsearch::Transport::Client, indices: indices_client) }
    let(:indices_client) { instance_double(Elasticsearch::API::Indices::IndicesClient) }
    let(:cluster) { instance_double(Elasticsearch::Resources::Cluster, client: client, settings: cluster_settings) }
    let(:cluster_settings) { instance_double(Elasticsearch::Resources::Configuration::Cluster, index: nil) }
    let(:name) { 'test_index' }

    before(:each) { allow(instance.settings).to receive(:name).and_return(name) }
    before(:each) { allow(cluster_settings).to receive(:index).and_return(nil) }

    describe 'behavior' do
      describe '#initialize' do
        context 'returns an Index with' do
          describe '#cluster' do
            subject { super().cluster }
            it { is_expected.to be(cluster) }
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

      describe '#setup!' do
        subject { super().setup! }
        context 'when the index' do
          before(:each) { allow(instance).to receive(:exists?).and_return(exists) }

          context 'doesn\'t exist' do
            let(:exists) { false }
            before(:each) { expect(instance).to receive(:create) }
            it { is_expected.to be nil }
          end

          context 'exists' do
            let(:exists) { true }
            before(:each) { expect(instance).to_not receive(:create) }
            it { is_expected.to be nil }
          end
        end
      end

      describe '#teardown!' do
        subject { super().teardown! }
        context 'when the index' do
          before(:each) { allow(instance).to receive(:exists?).and_return(exists) }

          context 'doesn\'t exist' do
            let(:exists) { false }
            before(:each) { expect(instance).to_not receive(:delete) }
            it { is_expected.to be nil }
          end

          context 'exists' do
            let(:exists) { true }
            before(:each) { expect(instance).to receive(:delete) }
            it { is_expected.to be nil }
          end
        end
      end

      describe '#types' do
        subject { super().types }
        it { is_expected.to be_a_kind_of(Array) }
        it { is_expected.to be_empty }
      end

      describe '#query_index' do
        subject { super().query_index(action, **options) }
        let(:action) { :exists? }
        let(:options) { { test: true } }
        let(:params) { { index: name }.merge(options) }
        let(:result) { double('result') }

        before(:each) { expect(indices_client).to receive(action).with(**params).and_return(result) }

        it { is_expected.to be(result) }
      end

      describe '#query' do
        subject { super().query(action, **options) }
        let(:action) { :search }
        let(:options) { { test: true } }
        let(:params) { { index: name }.merge(options) }
        let(:response) { double('response') }

        before(:each) { allow_any_instance_of(Elasticsearch::Resources::ResponseFactory).to receive(:build).and_return(response) }
        before(:each) { expect(client).to receive(action).with(**params) }

        it { is_expected.to be(response) }
      end

      describe '#exists?' do
        subject { super().exists? }
        let(:result) { double('result') }
        before(:each) { expect(instance).to receive(:query_index).with(:exists?).and_return(result) }
        it { is_expected.to be(result) }
      end

      describe '#create' do
        subject { super().create }
        let(:result) { double('result') }
        before(:each) { expect(instance).to receive(:query_index).with(:create).and_return(result) }
        it { is_expected.to be(result) }
      end

      describe '#put_mapping' do
        subject { super().put_mapping(**options) }
        let(:options) { {} }
        let(:result) { double('result') }
        before(:each) { expect(instance).to receive(:query_index).with(:put_mapping, options).and_return(result) }
        it { is_expected.to be(result) }
      end

      describe '#delete' do
        subject { super().delete }
        let(:result) { double('result') }
        before(:each) { expect(instance).to receive(:query_index).with(:delete).and_return(result) }
        it { is_expected.to be(result) }
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

      describe '#find_index' do
        subject { super().find_index(index: index_name) }
        
        context 'when the index name' do
          context 'does not match' do
            let(:index_name) { :unknown }
            it { is_expected.to be nil }
          end

          context 'matches' do
            context 'by Symbol' do
              let(:index_name) { name.to_sym }
              it { is_expected.to be(instance) }
            end

            context 'by String' do
              let(:index_name) { name.to_s }
              it { is_expected.to be(instance) }
            end
          end
        end
      end

      describe '#find_type' do
        subject { super().find_type(index: index_name, type: type_name) }
        let(:index_name) { :test_index }
        let(:type_name) { :test_type }

        let(:types) { [type] }
        let(:type) { instance_double(Elasticsearch::Resources::Type) }

        before(:each) { allow(instance).to receive(:types).and_return(types) }
        before(:each) { expect(type).to receive(:find_type).with(type: type_name).and_return(type) }
        it { is_expected.to be(type) }
      end
    end
  end
end
