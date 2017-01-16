module Elasticsearch
  module Resources
    class Index
      include Resource

      define_configuration \
        class_name: Configuration::Index,
        default: -> { cluster.settings.index(self.class.configuration.id) }

      attr_reader :cluster

      def initialize(cluster:, &block)
        self.cluster = cluster
        configure(id: self.class.configuration.id, cluster: cluster.settings, &block)
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

      def types
        []
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

      def find_index(index: nil)
        index.to_s == name.to_s ? self : nil
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
