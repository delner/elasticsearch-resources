module Elasticsearch
  module Resources
    class Type
      include Resource
      include Queryable
      include Configurable
      include Indexable
      include Nameable

      define_configuration \
        class_name: 'Elasticsearch::Resources::Configuration::Type',
        inherit_from: -> { index.settings.type(self.class.configuration.id) }

      ACTIONS = [
        :exists?,
        :create,
        :update,
        :delete,
        :get
      ].freeze

      def initialize(index:, &block)
        self.index = index
        configure(&block)
      end

      def cluster
        index.cluster
      end

      def client
        index.client
      end

      def name
        settings.name
      end

      def query(action, options = {})
        params = {
          index: index.name,
          type: name
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

      ACTIONS.each do |action|
        define_method action do |options = {}|
          query(action, options)
        end
      end

      def find_cluster
        self.cluster
      end

      def find_index(index: nil)
        self.index
      end

      def find_type(index: nil, type:)
        matches_name?(type) ? self : nil
      end

      def document_class
        self.class.document_class
      end

      def self.document_class
        Object.const_get(@document_class) if @document_class
      end

      protected

      def self.define_document(document_class)
        @document_class = (document_class.class == Class ? document_class.name : document_class)
      end

      define_document 'Elasticsearch::Resources::Document'
    end
  end
end
