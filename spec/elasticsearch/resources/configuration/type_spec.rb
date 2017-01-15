# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources::Configuration::Type do
  subject { described_class }

  describe 'class' do
    describe 'behavior' do
    end
  end

  describe 'instance' do
    describe 'behavior' do
      subject { instance }

      let(:instance) { described_class.new(id: id, index: index) }
      let(:id) { double('id') }
      let(:index) { instance_double(Elasticsearch::Resources::Configuration::Index) }

      describe '#initialize' do
        let(:instance) do
          described_class.new(
            id: id,
            index: index,
            name: name
          )
        end
        let(:name) { double('name') }

        context 'returns a Type with' do
          describe '#id' do
            subject { super().id }
            it { is_expected.to eq(id) }
          end

          describe '#index' do
            subject { super().index }
            it { is_expected.to eq(index) }
          end

          describe '#name' do
            subject { super().name }
            it { is_expected.to eq(name) }
          end
        end
      end

      describe '#id' do
        it { is_expected.to respond_to(:id) }
      end

      describe '#index' do
        it { is_expected.to respond_to(:index) }
      end

      describe '#name' do
        it { is_expected.to respond_to(:name) }
        it { is_expected.to respond_to(:name=) }
      end
    end
  end
end
