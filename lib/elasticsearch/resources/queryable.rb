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
        def query(action, params = {})
          raise NullClientError.new if client.nil?
          response = client.send(action, **params)
          ResponseFactory.build!(context: self, action: action, response: response)
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
