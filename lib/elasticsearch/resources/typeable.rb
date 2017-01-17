module Elasticsearch
  module Resources
    module Typeable
      def self.included(base)
        base.extend(ClassMethods)
        base.include(InstanceMethods)
      end

      module ClassMethods
      end

      module InstanceMethods
        attr_reader :type

        protected

        def type=(type)
          raise NullTypeError.new if type.nil?
          @type = type
        end
      end

      class NullTypeError < ArgumentError
        def initialize
          super(message)
        end

        def message
          I18n.t('elasticsearch.resources.typeable.null_type_error.message')
        end
      end
    end
  end
end
