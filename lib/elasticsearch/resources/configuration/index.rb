module Elasticsearch
  module Resources
    module Configuration
      class Index
        attr_reader :id, :cluster
        attr_accessor :name

        def initialize(id:, cluster:, name: nil)
          @id = id
          @cluster = cluster
          @name = name.to_s
        end

        def types
          @types ||= default_types
        end

        def type(id)
          types.find { |t| t.id == id.to_sym }.tap do |t|
            yield(t) if block_given? && !t.nil?
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
