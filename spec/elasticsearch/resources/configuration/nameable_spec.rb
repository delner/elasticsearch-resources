# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources::Configuration::Nameable do
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
        describe '#name' do
          subject { super().name }
          it { is_expected.to be nil }
        end

        describe '#name=' do
          subject { super().send(:name=, name) }

          context 'given an ID that is' do
            context 'nil' do
              let(:name) { nil }
              it { expect { subject }.to raise_error(Elasticsearch::Resources::Configuration::Nameable::NullNameError) }
            end

            context 'a String' do
              let(:name) { 'test' }
              it { is_expected.to eq(name) }
              it { expect { subject }.to change { instance.name }.from(nil).to(name) }
            end
          end
        end
      end
    end
  end
end
