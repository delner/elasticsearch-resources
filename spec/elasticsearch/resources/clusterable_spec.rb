# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources::Clusterable do
  subject { described_class }

  describe 'implemented' do
    let(:test_class) do
      (stub_const "TestClass", Class.new).tap do |klass|
        klass.send(:include, described_class)
      end
    end

    describe 'class' do
      subject { test_class }

      describe 'behavior' do
      end
    end

    describe 'instance' do
      subject { instance }
      let(:instance) { test_class.new }

      describe 'behavior' do
        describe '#cluster' do
          subject { super().cluster }
          it { is_expected.to be nil }
        end

        describe '#cluster=' do
          subject { super().send(:cluster=, cluster) }

          context 'given an Cluster that is' do
            context 'nil' do
              let(:cluster) { nil }
              it { expect { subject }.to raise_error(Elasticsearch::Resources::Clusterable::NullClusterError) }
            end

            context 'a Cluster' do
              let(:cluster) { instance_double(Elasticsearch::Resources::Cluster) }
              it { is_expected.to eq(cluster) }
              it { expect { subject }.to change { instance.cluster }.from(nil).to(cluster) }
            end
          end
        end
      end
    end
  end
end
