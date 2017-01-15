# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources::Configuration::Cluster do
  subject { described_class }

  describe 'class' do
    describe 'behavior' do
    end
  end

  describe 'instance' do
    subject { instance }

    let(:instance) { described_class.new(id: id) }
    let(:id) { double('id') }

    describe 'behavior' do
      describe '#initialize' do
        let(:instance) do
          described_class.new(
            id: id,
            host: host
          )
        end
        let(:host) { double('host') }

        context 'returns a Cluster with' do
          describe '#id' do
            subject { super().id }
            it { is_expected.to eq(id) }
          end

          describe '#host' do
            subject { super().host }
            it { is_expected.to eq(host) }
          end
        end
      end

      describe '#id' do
        it { is_expected.to respond_to(:id) }
      end

      describe '#host' do
        it { is_expected.to respond_to(:host) }
        it { is_expected.to respond_to(:host=) }
      end

      describe '#client' do
        subject { super().client }
        let(:host) { double('host') }
        let(:client) { instance_double(Elasticsearch::Client) }

        before(:each) { allow(instance).to receive(:host).and_return(host) }

        it do
          expect(Elasticsearch::Client).to receive(:new).with(host: host).once.and_return(client)
          is_expected.to be(client)
          # Trigger second time to ensure it's not creating multiple clients.
          expect(instance.client).to be(client)
        end
      end

      describe '#indexes' do
        subject { super().indexes }
        it { is_expected.to be_a_kind_of(Array) }
        it { is_expected.to be_empty }
      end

      describe '#index' do
        subject { super().index(index_id) }
        let(:index_id) { :test_index }

        context 'when the Cluster has no indexes' do
          it { is_expected.to be nil }
        end

        context 'when the Cluster contains a index' do
          context 'that matches the ID provided' do
            let(:index) { instance_double(Elasticsearch::Resources::Configuration::Index, id: index_id) }
            before(:each) { allow(instance).to receive(:indexes).and_return([index]) }
            it { is_expected.to be(index) }
            it { expect { |b| instance.index(index_id, &b) }.to yield_with_args(index) }
          end
        end
      end
    end
  end
end
