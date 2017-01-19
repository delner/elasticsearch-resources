module Elasticsearch
  module Resources
    module Configurable
      def self.included(base)
        base.extend(ClassMethods)
        base.include(InstanceMethods)
      end

      module ClassMethods
        def configuration
          @configuration ||= superclass.respond_to?(:configuration) ? superclass.configuration.dup : Configuration.new
        end

        protected

        def define_configuration(attributes = {})
          @configuration = configuration.tap do |c|
            c.set_attributes(attributes)
          end
        end
      end

      module InstanceMethods
        attr_accessor :settings

        def default_settings
          default_id = self.class.configuration.id
          self.class.configuration.configuration_class&.new(id: default_id).tap do |s|
            defaults_block = self.class.configuration.defaults
            self.instance_exec(s, &defaults_block) if defaults_block
          end
        end

        def inherited_settings
          inherit_block = self.class.configuration.inherit_from
          if inherit_block
            s = self.instance_exec(&inherit_block)&.dup
          else
            nil
          end
        end

        def configure(&block)
          @settings = inherited_settings || default_settings
          settings.tap do |s|
            yield(s) if block_given?
          end
        end
      end

      class Configuration
        ATTRIBUTES = [:id, :class_name, :inherit_from, :defaults].freeze

        attr_accessor *ATTRIBUTES

        def set_attributes(attributes = {})
          attributes.each do |name, value|
            self.send("#{name.to_s}=", value) if self.respond_to?("#{name.to_s}=")
          end
        end

        def class_name=(class_name)
          @class_name = (class_name.class == Class ? class_name.name : class_name)
        end

        def configuration_class
          class_name ? Object.const_get(class_name) : nil
        end

        def ==(obj)
          ATTRIBUTES.all? { |a| obj.send(a) == self.send(a) }
        end
      end
    end
  end
end
