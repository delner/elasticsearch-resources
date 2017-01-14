module Elasticsearch
  module Resources
    module ResponseFactory
      def self.build!(context:, action:, response:)
        case action
        when :get
          build_get!(context: context, response: response)
        when :search
          build_search!(context: context, response: response)
        else
          response
        end
      end

      def self.build_get!(context:, response:)
        DocumentFactory.build!(
          type: get_document_type!(context: context, document: response),
          document: response
        )
      end

      def self.build_search!(context:, response:)
        documents = response['hits']['hits']
        documents.collect do |document|
          DocumentFactory.build!(
            type: get_document_type!(context: context, document: document),
            document: document
          )
        end
      end

      def self.get_document_type(context:, document:)
        index_name = document['_index']
        type_name = document['_type']
        context.find_type(index: index_name, type: type_name)
      end

      def self.get_document_type!(context:, document:)
        get_document_type(context: context, document: document).tap do |t|
          raise UnknownTypeError.new(index: index_name, type: type_name, document: document) if t.nil?
        end
      end

      class UnknownTypeError < StandardError
        attr_reader :index, :type, :document

        def initialize(index:, type:, document:)
          super(I18n.t('elasticsearch.resources.document_factory.unknown_type_error.message'))
          @document = index
          @document = type
          @document = document
        end
      end
    end
  end
end
