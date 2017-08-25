require 'torznab/client/errors/xml_error'

module Torznab
  module Client
    module Caps
      module Mappers
        # Category mapping
        module CategoryOrSubcategoryMapper
          private

          def map_id(xml_element)
            attribute_id = xml_element.attribute 'id'
            raise XmlError, 'Id attribute must be defined' if attribute_id.nil?
            raise XmlError, 'Id attribute format must be an integer' unless /\A\d+\z/ =~ attribute_id.value
            attribute_id.value.to_i
          end

          def map_name(xml_element)
            attribute_name = xml_element.attribute 'name'
            raise XmlError, 'Name attribute must be defined' if attribute_name.nil?
            attribute_name.value
          end

          XmlError = Torznab::Client::Errors::XmlError
        end
      end
    end
  end
end
