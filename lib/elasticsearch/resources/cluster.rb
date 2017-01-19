module Elasticsearch
  module Resources
    class Cluster
      include Resource
      include Queryable
      include Configurable
      include Nameable

      define_configuration class_name: 'Elasticsearch::Resources::Configuration::Cluster'

      def initialize(&block)
        configure(&block)
      end

      def setup!
        client
        super
      end

      def client
        settings.client
      end

      def indexes
        @indexes ||= self.class.indexes.collect do |index_class|
          index_class.new(cluster: self).tap do |index|
            settings.index(index_class.configuration.id).tap do |settings|
              index.settings = settings.dup unless settings.nil?
            end
          end
        end
      end

      def search(body, options = {})
        params = {
          body: body
        }.merge(options)

        query(:search, params)
      end

      def count(body, options = {})
        params = {
          body: body
        }.merge(options)

        query(:count, params)
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

      protected

      def self.indexes
        (@index_names ||= []).collect { |i| Object.const_get(i) }
      end

      def self.define_indexes(*indexes)
        @index_names = indexes.collect { |i| i.class == Class ? i.name : i }
      end
    end
  end
end
