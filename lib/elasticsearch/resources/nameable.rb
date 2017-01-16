module Elasticsearch
  module Resources
    module Nameable
      def self.included(base)
        base.extend(ClassMethods)
        base.include(InstanceMethods)
      end

      module ClassMethods
        attr_reader :default_name

        def define_default_name(name)
          @default_name = name&.to_s
        end
      end

      module InstanceMethods
        def name
          self.class.default_name
        end

        def matches_name?(name)
          name.to_s == self.name.to_s
        end
      end
    end
  end
end
