module Elasticsearch
  module Resources
    class Index
      include Resource

      define_configuration \
        class_name: Configuration::Index,
        default: -> { cluster.settings.index(self.class.configuration[:id]) }

      attr_reader :cluster

      def initialize(cluster:, &block)
        self.cluster = cluster
        configure(id: self.class.configuration[:id], cluster: cluster.settings, &block)
      end

      def client
        cluster.client
      end

      def name
        settings.name
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

      def repositories
        types
      end

      def types
        []
      end

      def exists?
        client.indices.exists? index: name
      end

      def create
        client.indices.create index: name
      end

      def put_mapping(options = {})
        params = {
          index: name
        }.merge(options)

         client.indices.put_mapping(params)
      end

      def delete
        client.indices.delete index: name
      end

      def query(action, options = {})
        params = {
          index: name
        }.merge(options)

        super(action, **params)
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

      def find_index(index: nil)
        index == name ? self : nil
      end

      def find_type(index: nil, type:)
        types.find do |t|
          t.find_type(type: type)
        end
      end

      protected

      attr_writer :cluster
    end
  end
end
