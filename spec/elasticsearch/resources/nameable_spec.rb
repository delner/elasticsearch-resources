# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources::Nameable do
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

        describe '#matches_name?' do
          subject { super().matches_name?(name) }

          context 'given a name that' do
            context 'matches' do
              let(:name) { instance.name }
              it { is_expected.to be true }
            end

            context 'doesn\'t match' do
              let(:name) { 'non-matching_name' }
              it { is_expected.to be false }
            end
          end
        end
      end
    end
  end
end
