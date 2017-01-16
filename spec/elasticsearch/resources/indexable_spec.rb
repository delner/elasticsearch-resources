# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources::Indexable do
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
        describe '#index' do
          subject { super().index }
          it { is_expected.to be nil }
        end

        describe '#index=' do
          subject { super().send(:index=, index) }

          context 'given an index that is' do
            context 'nil' do
              let(:index) { nil }
              it { expect { subject }.to raise_error(Elasticsearch::Resources::Indexable::NullIndexError) }
            end

            context 'an Elasticsearch::Resources::Index' do
              let(:index) { instance_double(Elasticsearch::Resources::Index) }
              it { is_expected.to eq(index) }
              it { expect { subject }.to change { instance.index }.from(nil).to(index) }
            end
          end
        end
      end
    end
  end
end
