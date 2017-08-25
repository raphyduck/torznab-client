require 'torznab/client/caps/category'
require 'torznab/client/caps/mappers/subcategory_mapper'
require 'torznab/client/errors/xml_error'
require 'nokogiri'

module Torznab
  module Client
    module Caps
      module Mappers
        # Category mapping
        module CategoryMapper
          extend Torznab::Client::Caps::Mappers::CategoryOrSubcategoryMapper

          class << self
            # Map the data from a Nokogiri::XML::Element to a Category object
            # corresponding of a category node of the caps xml
            #
            # @param [Nokogiri::XML::Element] xml_element data from a category node to map
            # @return [Torznab::Client::Caps::Searching] Mapped Category instance
            # @raise [Torznab::Client::Errors::XmlError]
            def map(xml_element)
              unless xml_element.is_a? Nokogiri::XML::Element
                raise XmlError, 'Provided object is not a Nokogiri::XML::Element'
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
end
