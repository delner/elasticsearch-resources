module Elasticsearch
  module Resources
    module Configuration
      module Nameable
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
        end

        module ClassMethods
        end

        module InstanceMethods
          attr_reader :name

          def name=(name)
            raise NullNameError.new if name.nil?
            @name = name.to_s
          end
        end

        class NullNameError < ArgumentError
          def initialize
            super(message)
          end

          def message
            I18n.t('elasticsearch.resources.configuration.nameable.null_name_error.message')
          end
        end
      end
    end
  end
end
