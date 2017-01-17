# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources::Configuration::Index do
  subject { described_class }

  describe 'class' do
    describe 'behavior' do
    end
  end

  describe 'instance' do
    subject { instance }

    let(:instance) { described_class.new(id: id, cluster: cluster) }
    let(:id) { double('id') }
    let(:cluster) { instance_double(Elasticsearch::Resources::Configuration::Cluster) }

    describe 'behavior' do
      describe '#initialize' do
        let(:instance) do
          described_class.new(
            id: id,
            cluster: cluster
          )
        end

        context 'returns an Index with' do
          describe '#id' do
            subject { super().id }
            it { is_expected.to eq(id) }
          end

          describe '#cluster' do
            subject { super().cluster }
            it { is_expected.to eq(cluster) }
          end
        end
      end

      describe '#id' do
        it { is_expected.to respond_to(:id) }
      end

      describe '#cluster' do
        it { is_expected.to respond_to(:cluster) }
      end

      describe '#name' do
        subject { super().name }
        it { is_expected.to eq(nil) }
      end

      describe '#name=' do
        subject { super().name = name }

        context 'given' do
          context 'nil' do
            let(:name) { nil }
            it { expect { subject }.to raise_error(Elasticsearch::Resources::Configuration::Index::NullNameError) }
          end

          context 'a String' do
            let(:name) { 'test' }

            context 'then #name' do
              subject { super(); instance.name }
              it { is_expected.to eq(name.to_s) }
            end
          end

          context 'a Symbol' do
            let(:name) { :test }

            context 'then #name' do
              subject { super(); instance.name }
              it { is_expected.to eq(name.to_s) }
            end
          end
        end
      end

      describe '#types' do
        subject { super().types }
        it { is_expected.to be_a_kind_of(Array) }
        it { is_expected.to be_empty }
      end

      describe '#type' do
        subject { super().type(type_id) }
        let(:type_id) { :test_type }

        context 'when the Index has no types' do
          it { is_expected.to be nil }
        end

        context 'when the Index contains a type' do
          context 'that matches the ID provided' do
            let(:type) { instance_double(Elasticsearch::Resources::Configuration::Type, id: type_id) }
            before(:each) { allow(instance).to receive(:types).and_return([type]) }
            it { is_expected.to be(type) }
            it { expect { |b| instance.type(type_id, &b) }.to yield_with_args(type) }
          end
        end
      end
    end
  end
end
