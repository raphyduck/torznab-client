require 'torznab/client/caps/search_modes'
require 'torznab/client/caps/mappers/search_mode_mapper'
require 'torznab/client/errors/xml_error'
require 'nokogiri'

module Torznab
  module Client
    module Caps
      module Mappers
        # Searching node mapping
        module SearchModesMapper
          class << self
            # Map the data from a Nokogiri::XML::Element to a Searching object
            # corresponding of a searching node of the caps xml
            #
            # @param [Nokogiri::XML::Element] xml_element data from searching node to map
            # @return [Torznab::Client::Caps::Searching] Mapped searching object
            # @raise [Torznab::Client::Errors::XmlError]
            def map(xml_element)
              unless xml_element.is_a? Nokogiri::XML::Element
                raise XmlError, 'Provided object is not a Nokogiri::XML::Element'
              end

              searching = SearchModes.new
              searching.search = map_search xml_element, 'search'
              searching.tv_search = map_search xml_element, 'tv-search'
              searching.movie_search = map_search xml_element, 'movie-search'
              searching
            end

            private

            def map_search(xml_element, xml_node_name)
              search_mode_element = xml_element.at(xml_node_name)
              raise XmlError, "Search mode with name #{xml_node_name} must exist" if search_mode_element.nil?
              SearchModeMapper.map search_mode_element
            end

            XmlError = Torznab::Client::Errors::XmlError
          end
        end
      end
    end
  end
end
