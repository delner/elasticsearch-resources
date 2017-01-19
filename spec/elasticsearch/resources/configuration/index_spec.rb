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

    let(:instance) { described_class.new }

    describe 'behavior' do
      describe '#types' do
        subject { super().types }
        it { is_expected.to be_a_kind_of(Hash) }
        it { is_expected.to be_empty }
      end

      describe '#type' do
        subject { super().type(key) }
        let(:key) { :test_type }

        context 'when the Index has no types' do
          it { is_expected.to be nil }
        end

        context 'when the Index contains a type' do
          context 'that matches the key provided' do
            let(:type) { instance_double(Elasticsearch::Resources::Configuration::Type) }
            before(:each) { allow(instance).to receive(:types).and_return({ key => type }) }
            it { is_expected.to be(type) }
            it { expect { |b| instance.type(key, &b) }.to yield_with_args(type) }
          end
        end
      end
    end
  end
end
