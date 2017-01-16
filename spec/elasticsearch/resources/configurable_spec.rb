# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources::Configurable do
  subject { described_class }

  let(:configuration_class) { Elasticsearch::Resources::Configurable::Configuration }

  describe 'implemented' do
    let(:test_class) do
      (stub_const "TestClass", Class.new).tap do |klass|
        klass.send(:include, described_class)
      end
    end

    shared_context 'inherits from parent Configurable class' do
      let(:parent_class) do
        (stub_const "ParentClass", Class.new).tap do |klass|
          klass.send(:include, described_class)
        end
      end

      let(:test_class) do
        (stub_const "TestClass", Class.new(parent_class)).tap do |klass|
          klass.send(:include, described_class)
        end
      end
    end

    describe 'class' do
      subject { test_class }

      describe 'behavior' do
        describe '#configuration' do
          subject { super().configuration }

          context 'returns a Configuration with' do
            it { is_expected.to be_a_kind_of(configuration_class) }

            describe '#id' do
              subject { super().id }
              it { is_expected.to be nil }
            end

            describe '#class_name' do
              subject { super().class_name }
              it { is_expected.to be nil }
            end

            describe '#default' do
              subject { super().default }
              it { is_expected.to be nil }
            end
          end

          context "when the class inherits from a Configurable class" do
            include_context 'inherits from parent Configurable class'

            let(:parent_class_configuration) { parent_class.configuration }

            it { is_expected.to be_a_kind_of(configuration_class) }
            # We don't want the configuration to be the parent configuration, just a copy.
            it { expect(parent_class_configuration).to be_a_kind_of(configuration_class) }
            it { is_expected.to_not be(parent_class_configuration) }
          end
        end

        describe '#define_configuration' do
          subject do
            super().send(
              :define_configuration,
              id: id,
              class_name: class_name,
              default: default
            )
          end

          let(:id) { double('id') }
          let(:class_name) { double('class_name') }
          let(:default) { double('default') }

          let(:test_class_configuration) do
            configuration_class.new.tap do |c|
              c.id = id
              c.class_name = class_name
              c.default = default
            end
          end

          it { is_expected.to be_a_kind_of(configuration_class) }
          it do
            expect(test_class.configuration).to eq(configuration_class.new)
            is_expected.to eq(test_class_configuration)
            expect(test_class.configuration).to eq(test_class_configuration)
            # TODO: This is broken because it seems that test class is not
            #       reset between examples, which creates a polluted initial state.
            # expect { subject }
            #   .to change { test_class.configuration }
            #   .from(configuration_class.new)
            #   .to(test_class_configuration)
          end

          context "when the class inherits from a Configurable class" do
            include_context 'inherits from parent Configurable class'

            let(:parent_id) { double('parent id') }
            let(:parent_class_name) { double('parent class_name') }
            let(:parent_default) { double('parent default') }

            before(:each) do
              parent_class.send(
                :define_configuration,
                id: parent_id,
                class_name: parent_class_name,
                default: parent_default
              )
            end

            let(:parent_class_configuration) do
              configuration_class.new.tap do |c|
                c.id = parent_id
                c.class_name = parent_class_name
                c.default = parent_default
              end
            end

            context 'and overriding parameters' do
              context 'are not provided' do
                subject { test_class.send(:define_configuration) }
                it { expect { subject }.to_not change { test_class.configuration } }
              end

              context 'are provided' do
                it do
                  expect(test_class.configuration).to eq(parent_class_configuration)
                  is_expected.to eq(test_class_configuration)
                  expect(test_class.configuration).to eq(test_class_configuration)
                  # TODO: This is broken because it seems that test class is not
                  #       reset between examples, which creates a polluted initial state.
                  # expect { subject }
                  #   .to change { test_class.configuration }
                  #   .from(parent_class_configuration)
                  #   .to(test_class_configuration)
                end
              end
            end
          end
        end
      end
    end

    describe 'instance' do
      subject { instance }

      let(:instance) { test_class.new }

      describe 'behavior' do
        describe '#default_settings' do
          subject { super().default_settings }
          let(:configuration) { instance_double(configuration_class, default: default) }

          before(:each) { allow(test_class).to receive(:configuration).and_return(configuration) }

          context 'if the configuration default value' do
            context 'is not set' do
              let(:default) { nil }
              it { is_expected.to be nil }
            end

            context 'is a Proc' do
              let(:default) { Proc.new { self.class.name == 'TestClass' } }
              it { is_expected.to be true }
            end
          end
        end

        describe '#configure' do
          subject { super().configure(**options) }
          let(:options) { { id: :test } }

          context 'given options' do
            context 'when default settings is' do
              before(:each) { allow(instance).to receive(:default_settings).and_return(default_settings) }

              context 'nil' do
                let(:default_settings) { nil }

                context 'and the configuration class name is' do
                  let(:configuration) { instance_double(configuration_class, class_name: class_name) }

                  before(:each) { allow(test_class).to receive(:configuration).and_return(configuration) }

                  context 'nil' do
                    let(:class_name) { nil }
                    it { is_expected.to be nil }
                  end

                  context 'a constant' do
                    let(:class_name) { double('constant') }
                    let(:settings) { instance_double('settings') }
                    before(:each) { allow(class_name).to receive(:new).with(**options).and_return(settings) }
                    it { is_expected.to be(settings) }
                  end
                end
              end

              context 'not nil' do
                let(:default_settings) { {} }
                it { is_expected.to eq(default_settings) }
                it { is_expected.to_not be(default_settings) }
              end
            end

            context 'and a block' do
              let(:settings) { instance_double('settings') }
              before(:each) { allow(instance).to receive(:settings).and_return(settings) }
              it { expect { |b| instance.configure(&b) }.to yield_with_args(settings) }
            end
          end
        end
      end
    end
  end
end
