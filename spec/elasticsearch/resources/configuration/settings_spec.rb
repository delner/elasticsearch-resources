# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources::Configuration::Settings do
  subject { described_class }

  describe 'class' do
    describe 'behavior' do
    end
  end

  describe 'instance' do
    subject { instance }

    let(:instance) { described_class.new }

    describe 'behavior' do
      describe '#initialize' do
        it { is_expected.to be_a_kind_of(described_class) }
      end

      describe '#clusters' do
        subject { super().clusters }
        it { is_expected.to be_a_kind_of(Array) }
        it { is_expected.to have(1).items }
      end

      describe '#cluster' do
        subject { super().cluster(cluster_id) }
        let(:cluster_id) { :test_cluster }

        context 'when the Settings has no clusters' do
          it { is_expected.to be nil }
        end

        context 'when the Settings contains a cluster' do
          context 'that matches the ID provided' do
            let(:cluster) { instance_double(Elasticsearch::Resources::Configuration::Cluster, id: cluster_id) }
            before(:each) { allow(instance).to receive(:clusters).and_return([cluster]) }
            it { is_expected.to be(cluster) }
            it { expect { |b| instance.cluster(cluster_id, &b) }.to yield_with_args(cluster) }
          end
        end
      end
    end
  end
end
