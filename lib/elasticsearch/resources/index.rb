module Elasticsearch
  module Resources
    class Index
      include Resource
      include Queryable
      include Configurable
      include Clusterable
      include Nameable

      define_configuration class_name: 'Elasticsearch::Resources::Configuration::Index'

      def initialize(cluster:, &block)
        self.cluster = cluster
        configure(&block)
      end

      def setup!
        unless exists?
          create
          super
        end
      end

      def teardown!
        if exists?
          delete
          super
        end
      end

      def client
        cluster.client
      end

      def name
        settings.name
      end

      def types
        @types ||= self.class.types.collect do |key, type_class|
          [
            key,
            build_type(key: key)
          ]
        end.to_h
      end

      def build_type(key:, type_class: nil)
        type_class = self.class.types[key] if type_class.nil?
        type_class&.new(index: self).tap do |type|
          settings.type(key).tap do |settings|
            type.settings = settings.dup unless settings.nil?
          end
        end
      end

      def query_index(action, options = {})
        params = {
          index: name
        }.merge(options)

        client.indices.send(action, **params)
      end

      def query(action, options = {})
        params = {
          index: name
        }.merge(options)

        super(action, **params)
      end

      def exists?
        query_index(:exists?)
      end

      def create
        query_index(:create)
      end

      def put_mapping(options = {})
        query_index(:put_mapping, options)
      end

      def delete
        query_index(:delete)
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
        self.cluster
      end

      def find_index(index: nil)
        matches_name?(index) ? self : nil
      end

      def find_type(index: nil, type:)
        types.find do |t|
          t.find_type(type: type)
        end
      end

      def self.types
        (@type_names ||= {}).collect do |key, type_name|
          [key, Object.const_get(type_name)]
        end.to_h
      end

      protected

      def self.define_types(types = {})
        @type_names = types.collect do |key, type|
          [key.to_sym, type.class == Class ? type.name : type]
        end.to_h
      end
    end
  end
end
