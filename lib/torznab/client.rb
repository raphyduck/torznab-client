require 'torznab/client/caps'

# Torznab APIs management
module Torznab
  # @see https://github.com/Sonarr/Sonarr/wiki/Implementing-a-Torznab-indexer
  # @see http://newznab.readthedocs.io/en/latest/misc/api/#caps
  # Ruby client to Torznab APIs.
  module Client
    extend Torznab::Client::Caps

    class << self
      # Returns a new Torznab::Client instance after initializing it
      #
      # @param [String] api_url
      # @param [String] api_key
      # @return [Torznab::Client] Initialized Torznab::Client instance
      # @raise [Torznab::Client::Errors::CapsError]
      def new(api_url, api_key = nil)
        fetch_caps_from_url api_url, api_key
        self
      end
    end
  end
end
