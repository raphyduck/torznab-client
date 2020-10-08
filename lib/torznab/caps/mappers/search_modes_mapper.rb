require_relative '../search_modes'
require_relative 'search_mode_mapper'
require_relative '../../errors/xml_error'
require 'nokogiri'

module Torznab
  class Caps
    class Mappers
      # Searching node mapping
      module SearchModesMapper
        class << self
          XmlError = Torznab::Errors::XmlError
          private_constant :XmlError

          # Map the data from a Nokogiri::XML::Element to a Searching object
          # corresponding of a searching node of the caps xml
          #
          # @param [Nokogiri::XML::Element] xml_element data from searching node to map
          # @return [Torznab::Caps::Searching] Mapped searching object
          # @raise [Torznab::Errors::XmlError]
          def map(xml_element)
            unless xml_element.is_a? Nokogiri::XML::Element
              raise XmlError, 'Provided object is not a Nokogiri::XML::Element'
            end

            searching = SearchModes.new
            xml_element.children.each do |el|
              next if el.name == 'text'
              attr_name = el.name.gsub('-', '_')
              searching.class.module_eval { attr_accessor attr_name.to_sym }
              eval("searching").method("#{attr_name}=").call map_search xml_element, el.name
            end
            searching
          end

          private

          def map_search(xml_element, xml_node_name)
            search_mode_element = xml_element.at(xml_node_name)
            raise XmlError, "Search mode with name #{xml_node_name} must exist" if search_mode_element.nil?
            SearchModeMapper.map search_mode_element
          end
        end
      end
    end
  end
end
