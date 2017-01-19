module Elasticsearch
  module Resources
    module Configuration
      class Type
        include Nameable

        attr_reader :id

        def initialize(id: nil)
          @id = id
        end
      end
    end
  end
end
