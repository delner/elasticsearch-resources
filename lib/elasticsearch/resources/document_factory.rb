module Elasticsearch
  module Resources
    module DocumentFactory
      def self.build!(type:, document:)
        type.document_class.new(
          type: type,
          id: document['_id'],
          attributes: document['_source']
        )
      end
    end
  end
end
