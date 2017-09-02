require 'torznab/client/caps/mappers/category_mapper'
require 'torznab/client/errors/xml_error'
require 'nokogiri'

module Torznab
  module Client
    module Caps
      module Mappers
        # Categories mapping
        module CategoriesMapper
          class << self
            # Map the data from a Nokogiri::XML::Element to a Categories object
            # corresponding of a categories node of the caps xml
            #
            # @param [Nokogiri::XML::Element] xml_element data from a category node to map
            # @return [Torznab::Client::Caps::Categories] Mapped Categories instance
            # @raise [Torznab::Client::Errors::XmlError]
            def map(xml_element)
              unless xml_element.is_a? Nokogiri::XML::Element
                raise XmlError, 'Provided object is not a Nokogiri::XML::Element'
              end

              map_categories xml_element
            end

            private

            def map_categories(xml_element)
              categories = []
              xml_element.search('category').each do |category_element|
                categories << CategoryMapper.map(category_element)
              end
              categories
            end
          end
        end
      end
    end
  end
end
