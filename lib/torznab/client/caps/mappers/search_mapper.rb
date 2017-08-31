require 'torznab/client/caps/search'
require 'torznab/client/errors/xml_error'
require 'nokogiri'

module Torznab
  module Client
    module Caps
      # Caps objects mapping
      module Mappers
        # Search mapping
        module SearchMapper
          class << self
            # Map the data from a Nokogiri::XML::Element to a Search object
            # corresponding of a search node of the caps xml
            #
            # @param [Nokogiri::XML::Element] xml_element data from search node to map
            # @return [Torznab::Client::Caps::Search] Mapped search object
            # @raise [Torznab::Client::Errors::XmlError]
            def map(xml_element)
              unless xml_element.is_a? Nokogiri::XML::Element
                raise XmlError, 'Provided object is not a Nokogiri::XML::Element'
              end

              search = Search.new
              search.type = map_type xml_element
              search.available = map_available xml_element
              search.supported_params = map_supported_params xml_element
              search
            end

            private

            def map_type(xml_element)
              xml_element.name
            end

            def map_available(xml_element)
              attribute_available = xml_element.attribute 'available'
              raise XmlError, 'Available attribute must be defined' if attribute_available.nil?
              raise XmlError, 'Available attribute must be either yes or no' if attribute_available.value != 'yes' &&
                                                                                attribute_available.value != 'no'
              attribute_available.value == 'yes'
            end

            def map_supported_params(xml_element)
              attribute_supported_params = xml_element.attribute 'supportedParams'
              attribute_supported_params.nil? ? nil : attribute_supported_params.value.split(',')
            end

            XmlError = Torznab::Client::Errors::XmlError
          end
        end
      end
    end
  end
end
