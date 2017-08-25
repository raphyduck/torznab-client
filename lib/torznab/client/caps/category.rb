require 'torznab/client/errors/caps_error'
require 'torznab/client/caps/subcategory'

module Torznab
  module Client
    module Caps
      # Category of the caps
      class Category
        attr_reader :id
        attr_reader :name
        attr_reader :subcategories

        def id=(id)
          raise CapsError, 'Id must be an integer' unless id.is_a? Integer
          @id = id
        end

        def name=(name)
          raise CapsError, 'Name must be a string' unless name.is_a? String
          @name = name
        end

        def subcategories=(subcategories)
          raise CapsError, 'Subcategories must be an array' unless subcategories.is_a? Array
          unless subcategories.reject { |element| element.is_a? Torznab::Client::Caps::Subcategory }.empty?
            raise CapsError, 'Subcategories must be composed only of Subcategory objects'
          end
          @subcategories = subcategories
        end

        CapsError = Torznab::Client::Errors::CapsError
      end
    end
  end
end
