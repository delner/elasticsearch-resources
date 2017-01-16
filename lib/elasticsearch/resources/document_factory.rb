module Elasticsearch
  module Resources
    class DocumentFactory
      attr_reader :type, :content

      def initialize(type:, content:)
        @type = type
        @content = content
      end

      def build
        type.document_class.new(
          type: type,
          id: content['_id'],
          attributes: content['_source']
        )
      end
    end
  end
end
