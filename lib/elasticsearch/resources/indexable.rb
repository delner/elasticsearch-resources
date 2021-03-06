module Elasticsearch
  module Resources
    module Indexable
      def self.included(base)
        base.extend(ClassMethods)
        base.include(InstanceMethods)
      end

      module ClassMethods
      end

      module InstanceMethods
        attr_reader :index

        protected

        def index=(index)
          raise NullIndexError.new if index.nil?
          @index = index
        end
      end

      class NullIndexError < ArgumentError
        def initialize
          super(message)
        end

        def message
          I18n.t('elasticsearch.resources.indexable.null_index_error.message')
        end
      end
    end
  end
end
