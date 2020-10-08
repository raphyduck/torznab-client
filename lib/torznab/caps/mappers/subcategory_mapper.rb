require_relative 'category_or_subcategory_mapper'
require_relative '../subcategory'
require_relative '../../errors/xml_error'
require 'nokogiri'

module Torznab
  class Caps
    class Mappers
      # Subcategory mapping
      module SubcategoryMapper
        extend Torznab::Caps::Mappers::CategoryOrSubcategoryMapper

        class << self
          # Map the data from a Nokogiri::XML::Element to a Subcategory object
          # corresponding of a subcat node of the caps xml
          #
          # @param [Nokogiri::XML::Element] xml_element data from subcat node to map
          # @return [Torznab::Caps::Searching] Mapped searching object
          # @raise [Torznab::Errors::XmlError]
          def map(xml_element)
            unless xml_element.is_a? Nokogiri::XML::Element
              raise XmlError, 'Provided object is not a Nokogiri::XML::Element'
            end

            subcategory = Subcategory.new
            subcategory.id = map_id xml_element
            subcategory.name = map_name xml_element
            subcategory
          end
        end
      end
    end
  end
end
