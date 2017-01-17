module Elasticsearch
  module Resources
    module Configuration
      class Cluster
        attr_reader :id, :name

        def initialize(id:)
          @id = id
        end

        def client
          @client ||= Elasticsearch::Client.new(host: host)
        end

        def indexes
          @indexes ||= default_indexes
        end

        def index(id)
          indexes.find { |t| t.id == id.to_sym }.tap do |t|
            yield(t) if block_given?
          end
        end

        def name=(name)
          raise NullNameError.new if name.nil?
          @name = name.to_s
        end

        def host
          @host ||= '127.0.0.1:9200'
        end

        def host=(host)
          raise NullHostError.new if host.nil?
          @host = host
        end

        class NullNameError < ArgumentError
          def initialize
            super(message)
          end

          def message
            I18n.t('elasticsearch.resources.configuration.cluster.null_name_error.message')
          end
        end

        class NullHostError < ArgumentError
          def initialize
            super(message)
          end

          def message
            I18n.t('elasticsearch.resources.configuration.cluster.null_host_error.message')
          end
        end

        protected

        def default_indexes
          []
        end
      end
    end
  end
end
