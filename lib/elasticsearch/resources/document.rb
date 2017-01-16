module Elasticsearch
  module Resources
    class Document
      include Queryable
      include Typeable
      include Identifiable
      include Describable

      def initialize(type:, id:, attributes: {})
        self.type = type
        self.id = id.to_s
        self.attributes = attributes
      end

      def client
        type.client
      end

      def index
        type.index
      end

      def query(action, options = {})
        params = {
          index: index.name,
          type: type.name,
          id: id
        }.merge(options)

        super(action, **params)
      end

      def create(options = {})
        params = {
          body: attributes
        }.merge(options)

        query(:create, params)
      end

      def update(options = {})
        params = {
          body: attributes
        }.merge(options)

        query(:update, params)
      end

      [:exists?, :delete, :get].each do |action|
        define_method action do |options = {}|
          query(action, options)
        end
      end

      def find_index(index: nil)
        self.index
      end

      def find_type(index: nil, type: nil)
        self.type
      end
    end
  end
end
