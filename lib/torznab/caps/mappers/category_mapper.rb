require_relative '../category'
require_relative 'subcategory_mapper'
require_relative '../../errors/xml_error'
require 'nokogiri'

module Torznab
  class Caps
    class Mappers
      # Category mapping
      module CategoryMapper
        extend Torznab::Caps::Mappers::CategoryOrSubcategoryMapper

        class << self
          # Map the data from a Nokogiri::XML::Element to a Category object
          # corresponding of a category node of the caps xml
          #
          # @param [Nokogiri::XML::Element] xml_element data from a category node to map
          # @return [Torznab::Caps::Searching] Mapped Category instance
          # @raise [Torznab::Errors::XmlError]
          def map(xml_element)
            unless xml_element.is_a? Nokogiri::XML::Element
              raise Torznab::Errors::XmlError, 'Provided object is not a Nokogiri::XML::Element'
            end

            category = Category.new
            category.id = map_id xml_element
            category.name = map_name xml_element
            category.subcategories = map_subcategories xml_element
            category
          end

          private

          def map_subcategories(xml_element)
            subcategories = []
            xml_element.search('subcat').each do |subcategory_element|
              subcategories << SubcategoryMapper.map(subcategory_element)
            end
            subcategories
          end
        end
      end
    end
  end
end
