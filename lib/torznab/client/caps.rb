require_relative 'caps/mappers/instance_mapper'
require_relative 'http'
require 'nokogiri'

module Torznab
  module Client
    # Capacities handling from the remote Torznab API
    #
    # @see https://github.com/Sonarr/Sonarr/wiki/Implementing-a-Torznab-indexer Newznab API Documentation
    # @see http://newznab.readthedocs.io/en/latest/misc/api/#caps Torznab API documentat
    module Caps
      attr_reader :caps

      # Default struct for caps fetching
      HTTP_CAPS_PARAMS = { t: :caps }.freeze

      # Fetch and validate Torznab API capabilities from base url
      # Initialize caps attribute if the capabilities could be parsed successfully
      #
      # @param [String] api_url
      # @param [String] api_key
      # @raise [Torznab::Client::Errors::CapsError]
      def fetch_caps_from_url
        validate_url Torznab::Client.api_url
        caps_xml = get_caps_xml Torznab::Client.api_url
        nokogiri_xml_document = parse_xml caps_xml
        @caps = map_caps nokogiri_xml_document
      end

      private

      def validate_url(api_url)
        require 'uri'
        raise Errors::CapsError, 'Provided url is not valid' unless api_url =~ /\A#{URI::DEFAULT_PARSER.make_regexp}\z/
      end

      def get_caps_xml(api_url)
        params = HTTP_CAPS_PARAMS.dup

        begin
          Torznab::Client::Http.get params
        rescue => error
          raise Errors::CapsError, "Error while trying to get caps data from #{api_url}.\nError was '#{error.message}'"
        end
      end

      def parse_xml(caps_xml)
        Nokogiri::XML caps_xml
      rescue => error
        raise Errors::XmlError, "Impossible to parse fetched response: #{error.message}"
      end

      def map_caps(nokogiri_xml_document)
        unless nokogiri_xml_document.is_a? Nokogiri::XML::Document
          raise Errors::XmlError, 'Provided object is not a Nokogiri::XML::Document'
        end

        caps_node = nokogiri_xml_document.at 'caps'
        raise Errors::XmlError, 'Impossible to find caps node. Is the url valid?' if caps_node.nil?
        Mappers::InstanceMapper.map caps_node
      end
    end
  end
end
