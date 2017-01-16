module Elasticsearch
  module Resources
    module Resource
      def self.included(base)
        base.extend(ClassMethods)
        base.include(InstanceMethods)
      end

      module ClassMethods
      end

      module InstanceMethods
        def find_cluster
          nil
        end

        def find_index(index: nil)
          nil
        end

        def find_type(index: nil, type: nil)
          nil
        end

        def setup!
          nil
        end

        def populate!
          nil
        end

        def teardown!
          nil
        end
      end
    end
  end
end
