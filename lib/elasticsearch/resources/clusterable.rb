module Elasticsearch
  module Resources
    module Clusterable
      def self.included(base)
        base.extend(ClassMethods)
        base.include(InstanceMethods)
      end

      module ClassMethods
      end

      module InstanceMethods
        attr_reader :cluster

        protected

        def cluster=(cluster)
          raise NullClusterError.new if cluster.nil?
          @cluster = cluster
        end
      end

      class NullClusterError < ArgumentError
        def initialize
          super(message)
        end

        def message
          I18n.t('elasticsearch.resources.clusterable.null_cluster_error.message')
        end
      end
    end
  end
end
