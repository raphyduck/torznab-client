require_relative 'errors/http_error'

require 'net/http'

module Torznab
  # HTTP calls handling
  class Http
    # API Prefix for torznab
    API_PATH = '/api'.freeze

    def initialize(api_url, api_key)
      @api_url = api_url
      @api_key = api_key
      @mechanize = Mechanize.new
    end

    # Do a GET request
    #
    # @param [String] url Resource to fetch
    # @param [Hash] params GET Parameters in a key/value form
    # @return [String] Contents of the provided url
    # @raise [SchemeError] If the URL don't begin with http or https
    # @raise [HttpError] If the status code is not 2XX
    def get(params = {})
      tries ||= 3
      uri = create_uri params.merge({'apikey' => @api_key})
      response = @mechanize.get(uri)
      process_response response
    rescue => e
      if (tries -= 1) >= 0
        sleep 1
        retry
      else
        raise e
      end
    end

    private

    def create_uri(params)
      uri = URI.parse @api_url
      if uri.scheme != 'http' && uri.scheme != 'https'
        raise Torznab::Errors::HttpError, 'Scheme must be either http or https'
      end
      uri_set_query_from_params uri, params
      uri_path_remove_last_slash uri
      uri_path_add_api uri
    end

    def uri_set_query_from_params(uri, params)
      uri.query = URI.encode_www_form params if params
      uri
    end

    def uri_path_remove_last_slash(uri)
      uri.path = uri.path[0..-2] if !uri.path.empty? && uri.path[-1, 1] == '/'
      uri
    end

    def uri_path_add_api(uri)
      uri.path += API_PATH if uri.path[-4, 4] != API_PATH
      uri
    end

    def process_response(response)
      unless response.code.to_i == 200
        raise Torznab::Errors::HttpError,
              "Coudn't process response: #{response.code}"
      end
      response.body
    end
  end
end
