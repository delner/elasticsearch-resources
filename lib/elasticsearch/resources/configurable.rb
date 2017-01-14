module Elasticsearch
  module Resources
    module Configurable
      def self.included(base)
        base.extend(ClassMethods)
        base.include(InstanceMethods)
      end

      def self.prepended(base)
        base.extend(ClassMethods)
        base.prepend(InstanceMethods)
      end

      module ClassMethods
        def configuration
          @configuration ||= defined?(super) ? super.dup : {}
        end

        def define_configuration(id: nil, class_name: nil, default: nil)
          @configuration = configuration.dup.tap do |c|
            c.merge!(id: id) unless id.nil?
            c.merge!(class_name: class_name) unless class_name.nil?
            c.merge!(default: default) unless default.nil?
          end
        end
      end

      module InstanceMethods
        attr_reader :settings

        def default_settings
          default_expression = self.class.configuration[:default]
          default_expression ? self.instance_exec(&default_expression) : nil
        end

        def configure(options = {}, &block)
          @settings = default_settings&.dup || self.class.configuration[:class_name].new(**options)
          @settings.tap do |s|
            yield(s) if block_given?
          end
        end
      end
    end
  end
end
