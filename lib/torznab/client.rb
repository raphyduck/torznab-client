require_relative 'caps'

# Torznab APIs management
module Torznab
  # @see https://github.com/Sonarr/Sonarr/wiki/Implementing-a-Torznab-indexer
  # @see http://newznab.readthedocs.io/en/latest/misc/api/#caps
  # Ruby client to Torznab APIs.
  class Client
    attr_reader :caps, :http
    attr_accessor :api_key, :api_url
    # Returns a new Torznab::Client instance after initializing it
    #
    # @param [String] api_url
    # @param [String] api_key
    # @return [Torznab::Client] Initialized Torznab::Client instance
    # @raise [Torznab::Errors::CapsError]
    def initialize(aurl, akey = nil)
      @api_key = akey
      @api_url = aurl
      @http = Torznab::Http.new(aurl, akey)
      c = Torznab::Caps.new(http, aurl)
      @caps = c.caps
    end

    def get(params = {})
      begin
        http.get(params)
      rescue => error
        raise Errors::HttpError, "Error while trying to get http data from #{api_url}.\nError was '#{error.message}'"
      end
    end
  end
end
