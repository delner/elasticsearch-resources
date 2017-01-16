# frozen_string_literal: true
require 'spec_helper'

describe Elasticsearch::Resources::Queryable do
  subject { described_class }

  describe 'implemented' do
    let(:test_class) do
      (stub_const "TestClass", Class.new).tap do |klass|
        klass.send(:include, described_class)
      end
    end

    describe 'class' do
      subject { test_class }

      it { expect(subject < Elasticsearch::Resources::Resource).to be true }

      describe 'behavior' do
      end
    end

    describe 'instance' do
      subject { instance }
      let(:instance) { test_class.new }

      describe 'behavior' do
        describe '#query' do
          subject { super().query(action, **params) }
          let(:action) { :test }
          let(:params) { { id: :test } }

          context 'when the class' do
            context 'hasn\'t defined a client' do
              it { expect { subject }.to raise_error(NotImplementedError) }
            end

            context 'has defined a client that is' do
              before(:each) { allow(instance).to receive(:client).and_return(client) }

              context 'nil' do
                let(:client) { nil }
                it { expect { subject }.to raise_error(Elasticsearch::Resources::Queryable::NullClientError) }
              end

              context 'an Elasticsearch::Transport::Client' do
                let(:client) { instance_double(Elasticsearch::Transport::Client) }
                let(:response) { double('response') }
                let(:factory) { instance_double(Elasticsearch::Resources::ResponseFactory) }
                let(:factory_response) { double('factory response') }

                before(:each) do
                  expect(client).to receive(:send).with(action, **params).and_return(response)
                  expect(Elasticsearch::Resources::ResponseFactory).to receive(:new)
                    .with(resource: instance, action: action, response: response)
                    .and_return(factory)
                  expect(factory).to receive(:build).and_return(factory_response)
                end

                it { is_expected.to be(factory_response) }
              end
            end
          end
        end
      end
    end
  end
end
