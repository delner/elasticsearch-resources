module Elasticsearch
  module Resources
    module Describable
      def self.included(base)
        base.extend(ClassMethods)
        base.include(InstanceMethods)
      end

      module ClassMethods
        def attributes
          @attributes ||= []
        end

        protected

        def define_attributes(*attributes)
          new_attributes = attributes.collect(&:to_sym) - self.attributes.collect(&:to_sym)
          self.attributes.concat(new_attributes).tap { |a| define_attribute_helpers(new_attributes) }
        end

        private

        def define_attribute_helpers(attributes)
          attributes.each do |attribute|
            self.send(:define_method, "#{attribute}") do
              self.attributes[attribute.to_s]
            end

            self.send(:define_method, "#{attribute}=") do |value|
              self.attributes[attribute.to_s] = value
            end
          end
        end
      end

      module InstanceMethods
        def attributes
          @attributes ||= {}
        end

        protected

        def attributes=(attributes = {})
          @attributes = attributes.collect { |k, v| [k.to_s, v] }.to_h
        end
      end
    end
  end
end
