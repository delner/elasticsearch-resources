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

      it { expect(subject < Elasticsearch::Resources::Configurable).to be true }
      it { expect(subject < Elasticsearch::Resources::Queryable).to be true }

      describe 'behavior' do
      end
    end

    describe 'instance' do
      subject { instance }
      let(:instance) { test_class.new }

      describe 'behavior' do
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
