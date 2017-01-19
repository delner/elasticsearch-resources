module Elasticsearch
  module Resources
    module Nameable
      def self.included(base)
        base.extend(ClassMethods)
        base.include(InstanceMethods)
      end

      module ClassMethods
      end

      module InstanceMethods
        def name
          nil
        end

        def matches_name?(name)
          name.to_s == self.name.to_s
        end
      end
    end
  end
end
