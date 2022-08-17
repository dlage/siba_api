# frozen_string_literal: true

require_relative 'api/config'
require_relative 'version'

module SIBAApi
  # Stores the configuration
  class Configuration < API::Config
    property :follow_redirects, default: true

    # The api endpoint used to connect to SIBAApi if none is set
    property  :endpoint, default: 'https://api.fsapp.io/'

    # The value sent in the http header for 'User-Agent' if none is set
    property  :user_agent, default: "SIBAApi API Ruby Gem #{SIBAApi::VERSION}"

    # By default uses the Faraday connection options if none is set
    property  :connection_options, default: {}

    # By default display 30 resources
    property :per_page, default: 20

    # Add Faraday::RackBuilder to overwrite middleware
    property :stack
  end
end
