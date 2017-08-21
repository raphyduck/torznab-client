module Torznab
  module Client
    module Errors # Errors
      # Raised when a Xml fragment parsed from the caps xml is incorrect
      class XmlError < StandardError
      end
    end
  end
end
