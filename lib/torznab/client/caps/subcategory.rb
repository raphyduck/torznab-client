require 'torznab/client/errors/caps_error'

module Torznab
  module Client
    module Caps
      # Subcategory of the caps
      class Subcategory
        attr_reader :id
        attr_reader :name

        def id=(id)
          raise CapsError, 'Id must be an integer' unless id.is_a? Integer
          @id = id
        end

        def name=(name)
          raise CapsError, 'Name must be a string' unless name.is_a? String
          @name = name
        end

        CapsError = Torznab::Client::Errors::CapsError
      end
    end
  end
end
