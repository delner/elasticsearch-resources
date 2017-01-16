module Elasticsearch
  module Resources
    class ResponseFactory
      attr_reader :context, :action, :response

      def initialize(context:, action:, response:)
        @context = context
        @action = action
        @response = response
      end

      def build
        case action
        when :get
          build_get
        when :search
          build_search
        else
          response
        end
      end

      def build_get
        DocumentFactory.new(
          type: get_document_type!(content: response),
          content: response
        ).build
      end

      def build_search
        raw_documents = response['hits']['hits']
        raw_documents.collect do |raw_document|
          DocumentFactory.new(
            type: get_document_type!(content: raw_document),
            content: raw_document
          ).build
        end
      end

      def get_document_type(content:)
        context.find_type(index: content['_index'], type: content['_type'])
      end

      def get_document_type!(content:)
        get_document_type(content: content).tap do |type|
          raise UnknownTypeError.new(index: content['_index'], type: content['_type'], content: content) if type.nil?
        end
      end

      class UnknownTypeError < StandardError
        attr_reader :index, :type, :content

        def initialize(index:, type:, content:)
          @index = index
          @type = type
          @content = content
          super(I18n.t('elasticsearch.resources.document_factory.unknown_type_error.message', index: index, type: type))
        end
      end
    end
  end
end
