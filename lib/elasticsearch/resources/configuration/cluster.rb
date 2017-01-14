module Elasticsearch
  module Resources
    module Configuration
      class Cluster
        attr_reader :id
        attr_accessor :host

        def initialize(id:, host: nil)
          @id = id
          @host = host
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

        protected

        def default_indexes
          []
        end
      end
    end
  end
end
