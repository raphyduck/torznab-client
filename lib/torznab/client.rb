require_relative 'client/caps'

# Torznab APIs management
module Torznab
  # @see https://github.com/Sonarr/Sonarr/wiki/Implementing-a-Torznab-indexer
  # @see http://newznab.readthedocs.io/en/latest/misc/api/#caps
  # Ruby client to Torznab APIs.
  module Client
    extend Torznab::Client::Caps

    class << self
      attr_accessor :api_key, :api_url
      # Returns a new Torznab::Client instance after initializing it
      #
      # @param [String] api_url
      # @param [String] api_key
      # @return [Torznab::Client] Initialized Torznab::Client instance
      # @raise [Torznab::Client::Errors::CapsError]
      def new(aurl, akey = nil)
        @api_key = akey
        @api_url = aurl
        fetch_caps_from_url
        self
      end

      def get(params = {})
        begin
          ::Http.get(params)
        rescue => error
          raise Errors::HttpError, "Error while trying to get http data from #{api_url}.\nError was '#{error.message}'"
        end
      end
    end
  end
end
