require_relative 'search_modes_mapper'
require_relative 'categories_mapper'
require_relative '../instance'
require_relative '../../errors/xml_error'
require 'nokogiri'

module Torznab
    class Caps
      class Mappers
        # Instance of caps mapper
        module InstanceMapper
          class << self
            # Map the data from a Nokogiri::XML::Element to an Instance object
            # corresponding of the caps node of the caps xml
            #
            # @param [Nokogiri::XML::Element] xml_element data from a caps node to map
            # @return [Torznab::Caps::Instance] Mapped Caps instance
            # @raise [Torznab::Errors::XmlError]
            def map(xml_element)
              unless xml_element.is_a? Nokogiri::XML::Element
                raise XmlError, 'Provided object is not a Nokogiri::XML::Element'
              end

              caps = Torznab::Caps::Instance.new
              caps.search_modes = map_search_modes xml_element
              caps.categories = map_categories xml_element
              caps
            end

            private

            def map_search_modes(xml_element)
              node_searching = xml_element.at 'searching'
              raise XmlError, 'Searching node must be defined' if node_searching.nil?
              SearchModesMapper.map node_searching
            end

            def map_categories(xml_element)
              node_categories = xml_element.at 'categories'
              raise XmlError, 'Categories node must be defined' if node_categories.nil?
              CategoriesMapper.map node_categories
            end

            XmlError = Torznab::Errors::XmlError
          end
        end
      end
  end
end
