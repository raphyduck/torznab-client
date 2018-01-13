require 'torznab/client/caps/search_mode'
require 'torznab/client/errors/xml_error'
require 'nokogiri'

module Torznab
  module Client
    module Caps
      # Caps objects mapping
      module Mappers
        # SearchMode mapping
        module SearchModeMapper
          XmlError = Torznab::Client::Errors::XmlError
          private_constant :XmlError

          class << self
            # Map the data from a Nokogiri::XML::Element to a SearchMode object
            # corresponding of a search node of the caps xml
            #
            # @param [Nokogiri::XML::Element] xml_element data from search node to map
            # @return [Torznab::Client::Caps::SearchMode] Mapped search object
            # @raise [Torznab::Client::Errors::XmlError]
            def map(xml_element)
              unless xml_element.is_a? Nokogiri::XML::Element
                raise XmlError, 'Provided object is not a Nokogiri::XML::Element'
              end

              search_mode = SearchMode.new
              search_mode.type = map_type xml_element
              search_mode.available = map_available xml_element
              search_mode.supported_params = map_supported_params xml_element
              search_mode
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
          end
        end
      end
    end
  end
end
