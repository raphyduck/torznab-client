require_relative '../errors/caps_error'

module Torznab
  class Caps
    # Subcategory of the caps
    class Subcategory
      attr_reader :id
      attr_reader :name

      def id=(id)
        raise Torznab::Errors::CapsError, 'Id must be an integer' unless id.is_a? Integer
        @id = id
      end

      def name=(name)
        raise Torznab::Errors::CapsError, 'Name must be a string' unless name.is_a? String
        @name = name
      end
    end
  end
end