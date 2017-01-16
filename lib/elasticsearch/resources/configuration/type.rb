module Elasticsearch
  module Resources
    module Configuration
      class Type
        attr_reader :id, :name, :index

        def initialize(id:, index:)
          @id = id
          @index = index
        end

        def name=(name)
          raise NullNameError.new if name.nil?
          @name = name.to_s
        end

        class NullNameError < ArgumentError
          def initialize
            super(message)
          end

          def message
            I18n.t('elasticsearch.resources.configuration.type.null_name_error.message')
          end
        end
      end
    end
  end
end
