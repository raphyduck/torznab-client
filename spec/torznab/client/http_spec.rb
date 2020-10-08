require 'spec_helper'
require 'torznab/client/http'
require 'torznab/client/errors/http_error'

describe Torznab::Http do
  describe '.get' do
    subject { Torznab::Http.get url_get_request }

    context 'with http scheme' do
      let(:scheme) { 'http' }
      include_examples 'with valid scheme'
    end

    context 'with https scheme' do
      let(:scheme) { 'https' }
      include_examples 'with valid scheme'
    end

    context 'with other scheme' do
      subject { Torznab::Http.get 'httpz://test.net' }
      it { expect { subject }.to raise_error Torznab::Errors::HttpError, 'Scheme must be either http or https' }
    end
  end
end
