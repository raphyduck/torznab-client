require_relative 'search_modes'
require_relative 'category'
require_relative '../errors/caps_error'

module Torznab
  module Client
    module Caps
      # Capacities of the Torznab API
      class Instance
        attr_reader :search_modes
        attr_reader :categories

        def search_modes=(search_modes)
          unless search_modes.is_a? Torznab::Client::Caps::SearchModes
            raise Torznab::Client::Errors::CapsError, 'Search_modes must be a SearchModes instance'
          end
          @search_modes = search_modes
        end

        def categories=(categories)
          raise Torznab::Client::Errors::CapsError, 'Categories must be an array' unless categories.is_a? Array
          unless categories.reject { |category| category.is_a? Category }.empty?
            raise Torznab::Client::Errors::CapsError, 'Categories must be composed only of instances of Category'
          end
          @categories = categories
        end
      end
    end
  end
end
