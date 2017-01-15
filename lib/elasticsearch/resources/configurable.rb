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
          @configuration ||= superclass.respond_to?(:configuration) ? superclass.configuration.dup : Configuration.new
        end

        protected

        def define_configuration(options = {})
          @configuration = configuration.tap do |c|
            options.each do |name, value|
              c.send("#{name.to_s}=", value) if c.respond_to?("#{name.to_s}=") && !value.nil?
            end
          end
        end
      end

      module InstanceMethods
        attr_reader :settings

        def default_settings
          default_expression = self.class.configuration.default
          default_expression ? self.instance_exec(&default_expression) : nil
        end

        def configure(options = {}, &block)
          @settings = default_settings&.dup || self.class.configuration.class_name&.new(**options)
          settings.tap do |s|
            yield(s) if block_given?
          end
        end
      end

      class Configuration
        ATTRIBUTES = [:id, :class_name, :default].freeze

        attr_accessor *ATTRIBUTES

        def ==(obj)
          ATTRIBUTES.all? { |a| obj.send(a) == self.send(a) }
        end
      end
    end
  end
end
