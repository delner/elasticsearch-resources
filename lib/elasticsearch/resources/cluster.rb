module Elasticsearch
  module Resources
    class Cluster
      include Resource
      include Queryable
      include Configurable
      include Nameable

      define_configuration class_name: Configuration::Cluster

      def initialize(&block)
        configure(id: self.class.configuration.id, &block)
      end

      def setup!
        client
        super
      end

      def client
        settings.client
      end

      def indexes
        []
      end

      def find_cluster
        self
      end

      def find_index(index:)
        indexes.find do |i|
          i.find_index(index: index)
        end
      end

      def find_type(index:, type:)
        find_index(index: index)&.find_type(index: index, type: type)
      end
    end
  end
end
