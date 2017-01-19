# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources::Configuration::Type do
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
        context 'returns a Type with' do
          describe '#id' do
            subject { super().id }
            it { is_expected.to eq(id) }
          end
        end
      end

      describe '#id' do
        it { is_expected.to respond_to(:id) }
      end
    end
  end
end
