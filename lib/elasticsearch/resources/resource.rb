module Elasticsearch
  module Resources
    module Resource
      def self.included(base)
        base.include(Configurable)
        base.include(Queryable)
        base.extend(ClassMethods)
        base.include(InstanceMethods)
      end

      def self.prepended(base)
        base.prepend(Configurable)
        base.prepend(Queryable)
        base.extend(ClassMethods)
        base.prepend(InstanceMethods)
      end

      module ClassMethods
      end

      module InstanceMethods
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
