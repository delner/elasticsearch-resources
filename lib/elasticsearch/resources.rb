# Load library dependencies
require 'i18n'
require 'elasticsearch'

# Load classes and modules
require "elasticsearch/resources/version"
require 'elasticsearch/resources/configuration'

require 'elasticsearch/resources/configurable'
require 'elasticsearch/resources/identifiable'
require 'elasticsearch/resources/describable'
require 'elasticsearch/resources/indexable'
require 'elasticsearch/resources/typeable'
require 'elasticsearch/resources/queryable'
require 'elasticsearch/resources/document_factory'
require 'elasticsearch/resources/response_factory'

require 'elasticsearch/resources/resource'
require 'elasticsearch/resources/document'
require 'elasticsearch/resources/type'
require 'elasticsearch/resources/index'
require 'elasticsearch/resources/cluster'

module Elasticsearch
  module Resources
    def self.locales_paths
      Dir[File.join(File.expand_path('../resources', __FILE__), '**/locales/*.yml')]
    end
  end
end

# Load i18n locales
I18n.load_path += Elasticsearch::Resources.locales_paths
