module Elasticsearch
  module Resources
    module Queryable
      def self.included(base)
        base.include(Resource)
        base.extend(ClassMethods)
        base.include(InstanceMethods)
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
          ResponseFactory.new(resource: self, action: action, response: response).build
        end
      end

      class NullClientError < ArgumentError
        def initialize
          super(message)
        end

        def message
          I18n.t('elasticsearch.resources.queryable.null_client_error.message')
        end
      end
    end
  end
end
