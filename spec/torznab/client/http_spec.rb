require 'spec_helper'
require 'torznab/client/http'
require 'torznab/client/errors/http_error'

describe Torznab::Client::Http do
  describe '.get' do
    subject { Torznab::Client::Http.get url_get_request }

    context 'with http scheme' do
      let(:scheme) { 'http' }
      include_examples 'with valid scheme'
    end

    context 'with https scheme' do
      let(:scheme) { 'https' }
      include_examples 'with valid scheme'
    end

    context 'with other scheme' do
      subject { Torznab::Client::Http.get 'httpz://test.net' }
      it { expect { subject }.to raise_error Torznab::Client::Errors::HttpError, 'Scheme must be either http or https' }
    end
  end
end
