require 'torznab/client/caps/subcategory'
require 'torznab/client/errors/xml_error'
require 'nokogiri'

module Torznab
  module Client
    module Caps
      module Mappers
        # Subcategory mapping
        module SubcategoryMapper
          class << self
            # Map the data from a Nokogiri::XML::Element to a Subcategory object
            # corresponding of a subcat node of the caps xml
            #
            # @param [Nokogiri::XML::Element] xml_element data from subcat node to map
            # @return [Torznab::Client::Caps::Searching] Mapped searching object
            # @raise [Torznab::Client::Errors::XmlError]
            def map(xml_element)
              unless xml_element.is_a? Nokogiri::XML::Element
                raise XmlError, 'Provided object is not a Nokogiri::XML::Element'
              end

              subcategory = Subcategory.new
              subcategory.id = map_id xml_element
              subcategory.name = map_name xml_element
              subcategory
            end

            private

            XmlError = Torznab::Client::Errors::XmlError

            def map_id(xml_element)
              attribute_id = xml_element.attribute 'id'
              validate_id attribute_id
              attribute_id.value.to_i
            end

            def validate_id(attribute_id)
              raise XmlError, 'Id attribute must be defined' if attribute_id.nil?
              begin
                Float(attribute_id.value)
              rescue
                raise XmlError, 'Id attribute must be an integer'
              end
            end

            def map_name(xml_element)
              attribute_name = xml_element.attribute 'name'
              validate_name attribute_name
              attribute_name.value
            end

            def validate_name(attribute_name)
              raise XmlError, 'Name attribute must be defined' if attribute_name.nil?
            end
          end
        end
      end
    end
  end
end
