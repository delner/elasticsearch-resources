module Elasticsearch
  module Resources
    module Configuration
      class Settings
        def clusters
          @clusters ||= default_clusters
        end

        def cluster(id)
          clusters.find { |t| t.id == id.to_sym }.tap do |t|
            yield(t) if block_given?
          end
        end

        protected

        def default_clusters
          [
            Elasticsearch::Resources::Configuration::Cluster.new(id: :default)
          ]
        end
      end
    end
  end
end
