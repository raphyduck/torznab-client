require_relative '../errors/caps_error'

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

        def type=(type)
          raise Torznab::Client::Errors::CapsError, 'Type must be a valid caps search mode' unless type.include? 'search'
          @type = type
        end

        def available=(available)
          if !available.is_a?(TrueClass) && !available.is_a?(FalseClass)
            raise Torznab::Client::Errors::CapsError, 'Available must be a boolean'
          end

          @available = available
        end

        def supported_params=(supported_params)
          @supported_params = validate_supported_params supported_params, SEARCH_DEFAULT_SP
        end

        private

        def validate_supported_params(supported_params, default_params)
          return default_params if supported_params.nil?

          unless supported_params.is_a? Array
            raise Torznab::Client::Errors::CapsError, 'Supported params must either be an array or nil'
          end

          supported_params
        end
      end
    end
  end
end
