module Elasticsearch
  module Resources
    class DocumentFactory
      def build(type:, document:)
        type.document_class.new(
          type: type,
          id: document['_id'],
          attributes: document['_source']
        )
      end
    end
  end
end
