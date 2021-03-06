module Elasticsearch
  module Resources
    module Identifiable
      def self.included(base)
        base.extend(ClassMethods)
        base.include(InstanceMethods)
      end

      module ClassMethods
      end

      module InstanceMethods
        attr_reader :id

        protected

        def id=(id)
          raise NullIdError.new if id.nil?
          @id = id.to_s
        end
      end

      class NullIdError < ArgumentError
        def initialize
          super(message)
        end

        def message
          I18n.t('elasticsearch.resources.identifiable.null_id_error.message')
        end
      end
    end
  end
end
