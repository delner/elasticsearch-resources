# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources::Resource do
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
        describe '#find_cluster' do
          subject { super().find_cluster }
          it { is_expected.to be nil }
        end

        describe '#find_index' do
          subject { super().find_index(index: index) }
          let(:index) { double('index') }
          it { is_expected.to be nil }
        end

        describe '#find_type' do
          subject { super().find_type(index: index, type: type) }
          let(:index) { double('index') }
          let(:type) { double('type') }
          it { is_expected.to be nil }
        end

        describe '#setup!' do
          subject { super().setup! }
          it { is_expected.to be nil }
        end

        describe '#populate!' do
          subject { super().populate! }
          it { is_expected.to be nil }
        end

        describe '#teardown!' do
          subject { super().teardown! }
          it { is_expected.to be nil }
        end
      end
    end
  end
end
