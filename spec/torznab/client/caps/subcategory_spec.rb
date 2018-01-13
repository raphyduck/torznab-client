require 'spec_helper'
require 'torznab/client/caps/subcategory'

describe Torznab::Client::Caps::Subcategory do
  let(:subcategory) do
    subcategory = Torznab::Client::Caps::Subcategory.new
    subcategory.id = id if defined? id
    subcategory.name = name if defined? name
    subcategory
  end

  include_examples 'a caps category or subcategory'
end
