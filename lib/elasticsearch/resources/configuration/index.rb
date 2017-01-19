module Elasticsearch
  module Resources
    module Configuration
      class Index < Settings
        include Nameable

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
