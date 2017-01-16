# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources::Typeable do
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
        describe '#type' do
          subject { super().type }
          it { is_expected.to be nil }
        end

        describe '#type=' do
          subject { super().send(:type=, type) }

          context 'given an type that is' do
            context 'nil' do
              let(:type) { nil }
              it { expect { subject }.to raise_error(Elasticsearch::Resources::Typeable::NullTypeError) }
            end

            context 'an Elasticsearch::Resources::Type' do
              let(:type) { instance_double(Elasticsearch::Resources::Type) }
              it { is_expected.to eq(type) }
              it { expect { subject }.to change { instance.type }.from(nil).to(type) }
            end
          end
        end
      end
    end
  end
end
