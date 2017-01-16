module Elasticsearch
  module Resources
    module Configuration
      class Index
        attr_reader :id, :name, :cluster

        def initialize(id:, cluster:)
          @id = id
          @cluster = cluster
        end

        def types
          @types ||= default_types
        end

        def type(id)
          types.find { |t| t.id == id.to_sym }.tap do |t|
            yield(t) if block_given? && !t.nil?
          end
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
            I18n.t('elasticsearch.resources.configuration.index.null_name_error.message')
          end
        end

        protected

        def default_types
          []
        end
      end
    end
  end
end
