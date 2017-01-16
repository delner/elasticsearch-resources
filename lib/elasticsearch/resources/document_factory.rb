module Elasticsearch
  module Resources
    class DocumentFactory
      attr_reader :content, :resources

      def initialize(content:, resources: {})
        @content = content
        @resources = resources
      end

      def build
        type = get_type
        type.document_class.new(
          type: type,
          id: content['_id'],
          attributes: content['_source']
        )
      end

      def get_type
        resources[:type] || build_type
      end

      def build_type
        Elasticsearch::Resources::Type.new(index: get_index) do |type|
          type.name = content['_type']
        end
      end

      def get_index
        resources[:index] || build_index
      end

      def build_index
        Elasticsearch::Resources::Index.new(cluster: get_cluster) do |index|
          index.name = content['_index']
        end
      end

      def get_cluster
        resources[:cluster] || build_cluster
      end

      def build_cluster
        Elasticsearch::Resources::Cluster.new
      end
    end
  end
end
