require 'torznab/client/caps/search_modes'
require 'torznab/client/caps/category'
require 'torznab/client/errors/caps_error'

module Torznab
  module Client
    module Caps
      # Capacities of the Torznab API
      class Instance
        attr_reader :search_modes
        attr_reader :categories

        def search_modes=(search_modes)
          raise CapsError, 'Search_modes must be a SearchModes instance' unless search_modes.is_a? SearchModes
          @search_modes = search_modes
        end

        def categories=(categories)
          raise CapsError, 'Categories must be an array' unless categories.is_a? Array
          unless categories.reject { |category| category.is_a? Category }.empty?
            raise CapsError, 'Categories must be composed only of instances of Category'
          end
          @categories = categories
        end
      end
    end
  end
end
