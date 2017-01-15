# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources::Describable do
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
        describe '#attributes' do
          subject { super().attributes }
          it { is_expected.to be_a_kind_of(Array) }
          it { is_expected.to be_empty }
        end

        describe '#define_attributes' do
          subject { super().send(:define_attributes, *attr_names) }
          let(:attr_names) { [:test] }

          it do
            is_expected.to eq(attr_names)
            attr_names.each do |a|
              expect(test_class.instance_methods.include?(a.to_sym)).to be true
              expect(test_class.instance_methods.include?("#{a}=".to_sym)).to be true
            end
          end
        end
      end
    end

    describe 'instance' do
      subject { instance }
      let(:instance) { test_class.new }

      describe 'behavior' do
        describe '#attributes' do
          subject { super().attributes }
          it { is_expected.to be_a_kind_of(Hash) }
          it { is_expected.to be_empty }
        end

        describe '#attributes=' do
          subject { super().send(:attributes=, new_attributes) }

          context 'given a Hash with' do
            context 'Symbol keys' do
              let(:new_attributes) { { test: true } }
              it { is_expected.to eq({ 'test' => true }) }

              context 'then the instance' do
                context '#attributes' do
                  subject { super(); instance.attributes }
                  it { is_expected.to eq({ 'test' => true }) }
                end
              end
            end

            context 'String keys' do
              let(:new_attributes) { { 'test' => true } }
              it { is_expected.to eq(new_attributes) }
              it { is_expected.to_not be(new_attributes) }

              context 'then the instance' do
                context '#attributes' do
                  subject { super(); instance.attributes }
                  it { is_expected.to eq(new_attributes) }
                end
              end
            end
          end
        end
      end
    end
  end
end
