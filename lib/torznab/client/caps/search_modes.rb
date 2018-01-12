require 'torznab/client/caps/search_mode'
require 'torznab/client/errors/caps_error'

module Torznab
  module Client
    module Caps
      # Available search modes of the caps
      class SearchModes
        attr_reader :search
        attr_reader :tv_search
        attr_reader :movie_search

        def search=(search)
          validate_search_mode search
          @search = search
        end

        def tv_search=(tv_search)
          validate_search_mode tv_search
          @tv_search = tv_search
        end

        def movie_search=(movie_search)
          validate_search_mode movie_search
          @movie_search = movie_search
        end

        private

        def validate_search_mode(search_mode)
          return if search_mode.is_a? Torznab::Client::Caps::SearchMode
          raise Torznab::Client::Errors::CapsError,
                'Provided search mode must be an instance of Torznab::Client::Caps::SearchMode'
        end
      end
    end
  end
end
