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
        @indexes ||= self.class.indexes.collect do |key, index_class|
          [
            key,
            build_index(key: key)
          ]
        end.to_h
      end

      def build_index(key:, index_class: nil)
        index_class = self.class.indexes[key] if index_class.nil?
        index_class&.new(cluster: self).tap do |index|
          settings.index(key).tap do |settings|
            index.settings = settings.dup unless settings.nil?
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
        indexes.values.find do |i|
          i.find_index(index: index)
        end
      end

      def find_type(index:, type:)
        find_index(index: index)&.find_type(index: index, type: type)
      end

      def self.indexes
        (@index_names ||= {}).collect do |key, index_name|
          [key, Object.const_get(index_name)]
        end.to_h
      end

      protected

      def self.define_indexes(indexes = {})
        @index_names = indexes.collect do |key, index|
          [key.to_sym, index.class == Class ? index.name : index]
        end.to_h
      end
    end
  end
end
