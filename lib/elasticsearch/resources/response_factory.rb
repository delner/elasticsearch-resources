module Elasticsearch
  module Resources
    class ResponseFactory
      attr_reader :resource, :action, :response

      def initialize(resource:, action:, response:)
        @resource = resource
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
          content: response,
          resources: resources_for(response)
        ).build
      end

      def build_search
        raw_documents = response['hits']['hits']
        raw_documents.collect do |raw_document|
          DocumentFactory.new(
            content: raw_document,
            resources: resources_for(raw_document)
          ).build
        end
      end

      def resources_for(content)
        {
          cluster: resource.find_cluster,
          index: resource.find_index(index: content['_index']),
          type: resource.find_type(index: content['_index'], type: content['_type'])
        }
      end
    end
  end
end
