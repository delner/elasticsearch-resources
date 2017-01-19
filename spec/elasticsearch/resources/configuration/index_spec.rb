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

    let(:instance) { described_class.new(id: id) }
    let(:id) { double('id') }

    describe 'behavior' do
      describe '#initialize' do
        context 'returns an Index with' do
          describe '#id' do
            subject { super().id }
            it { is_expected.to eq(id) }
          end
        end
      end

      describe '#id' do
        it { is_expected.to respond_to(:id) }
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
