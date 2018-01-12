require 'torznab/client/errors/caps_error'

module Torznab
  module Client
    module Caps
      # Search mode of the caps
      class SearchMode
        attr_reader :type
        attr_reader :available
        attr_reader :supported_params

        # Default parameters for supported params of type search
        SEARCH_DEFAULT_SP = %w[q].freeze

        # Authorized parameters for supported params of type search
        SEARCH_AUTHORIZED_SP = %w[q].freeze

        # Default parameters for supported params of type tv-search
        TV_SEARCH_DEFAULT_SP = %w[q rid season ep].freeze

        # Authorized parameters for supported params of type tv-search
        TV_SEARCH_AUTHORIZED_SP = %w[q rid tvdbid tvmazeid season ep].freeze

        # Default parameters for supported params of type movie-search
        MOVIE_SEARCH_DEFAULT_SP = %w[q].freeze

        # Authorized parameters for supported params of type movie-search
        MOVIE_SEARCH_AUTHORIZED_SP = %w[q imdbid].freeze

        def type=(type)
          if type != 'search' && type != 'tv-search' && type != 'movie-search'
            raise Torznab::Client::Errors::CapsError, 'Type must be a valid caps search mode'
          end

          @type = type
        end

        def available=(available)
          if !available.is_a?(TrueClass) && !available.is_a?(FalseClass)
            raise Torznab::Client::Errors::CapsError, 'Available must be a boolean'
          end

          @available = available
        end

        def supported_params=(supported_params)
          @supported_params =
            case type
            when 'search'
              validate_supported_params supported_params, SEARCH_DEFAULT_SP, SEARCH_AUTHORIZED_SP
            when 'tv-search'
              validate_supported_params supported_params, TV_SEARCH_DEFAULT_SP, TV_SEARCH_AUTHORIZED_SP
            when 'movie-search'
              validate_supported_params supported_params, MOVIE_SEARCH_DEFAULT_SP, MOVIE_SEARCH_AUTHORIZED_SP
            else raise Torznab::Client::Errors::CapsError, 'Type must be initialized before setting supported_params'
            end
        end

        private

        def validate_supported_params(supported_params, default_params, allowed_params)
          return default_params if supported_params.nil?

          unless supported_params.is_a? Array
            raise Torznab::Client::Errors::CapsError, 'Supported params must either be an array or nil'
          end
          unless (supported_params - allowed_params).empty?
            raise Torznab::Client::Errors::CapsError, 'Supported params value is invalid'
          end

          supported_params
        end
      end
    end
  end
end
