# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources::Identifiable do
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
        describe '#id' do
          subject { super().id }
          it { is_expected.to be nil }
        end

        describe '#id=' do
          subject { super().send(:id=, id) }

          context 'given an ID that is' do
            context 'nil' do
              let(:id) { nil }
              it { expect { subject }.to raise_error(Elasticsearch::Resources::Identifiable::NullIdError) }
            end

            context 'a String' do
              let(:id) { 'test' }
              it { is_expected.to eq(id) }
              it { expect { subject }.to change { instance.id }.from(nil).to(id) }
            end
          end
        end
      end
    end
  end
end
