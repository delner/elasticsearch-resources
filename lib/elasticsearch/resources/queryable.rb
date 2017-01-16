module Elasticsearch
  module Resources
    module Queryable
      def self.included(base)
        base.extend(ClassMethods)
        base.include(InstanceMethods)
      end

      def self.prepended(base)
        base.extend(ClassMethods)
        base.prepend(InstanceMethods)
      end

      module ClassMethods
      end

      module InstanceMethods
        def client
          raise NotImplementedError.new(I18n.t('elasticsearch.resources.queryable.client.not_implemented_error'))
        end

        def query(action, params = {})
          raise NullClientError.new if client.nil?
          response = client.send(action, **params)
          ResponseFactory.new(context: self, action: action, response: response).build
        end

        def find_index(index: nil)
          nil
        end

        def find_type(index: nil, type: nil)
          nil
        end
      end

      class NullClientError < ArgumentError
        def initialize
          super(I18n.t('elasticsearch.resources.queryable.null_client_error.message'))
        end
      end
    end
  end
end
