require 'spec_helper'

RSpec.describe Torznab::Client do
  it 'has a version number' do
    expect(Torznab::Client::VERSION).not_to be nil
  end
end
