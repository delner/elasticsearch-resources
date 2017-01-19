module Elasticsearch
  module Resources
    module Configuration
      class Settings
        attr_reader :id

        def initialize(id: nil)
          @id = id
        end
      end
    end
  end
end
