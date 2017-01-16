module Elasticsearch
  module Resources
    module Configuration
      class Type
        attr_reader :id, :index
        attr_accessor :name

        def initialize(id:, index:, name: nil)
          @id = id
          @index = index
          @name = name.to_s
        end
      end
    end
  end
end
