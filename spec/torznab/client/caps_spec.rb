require 'spec_helper'
require 'torznab/client/caps'

describe Torznab::Client::Caps do
  describe '#fetch_caps_from_url' do
    before do
      instance = Torznab::Client::Caps::Instance.new
      allow(Torznab::Client::Caps::Mappers::InstanceMapper).to receive(:map).and_return instance
    end

    let(:client) { Class.new { extend Torznab::Client::Caps } }
    let(:stub_query) do
      query = Torznab::Client::Caps::HTTP_CAPS_PARAMS.dup
      query['apikey'] = api_key unless api_key.nil?
      query
    end

    subject { client.fetch_caps_from_url Torznab::Client.api_url, Torznab::Client.api_key }

    describe 'when url start with' do
      before { stub_request(:get, Torznab::Client.api_url).with(query: stub_query).to_return status: 200, body: '<caps></caps>' }
      let(:api_key) { nil }

      context 'http' do
        let(:api_url) { 'http://test.net/torznab/api' }
        it { expect(subject).to be_a Torznab::Client::Caps::Instance }
      end

      context 'https' do
        let(:api_url) { 'https://test.net/torznab/api' }
        it { expect(subject).to be_a Torznab::Client::Caps::Instance }
      end

      context 'httpz' do
        let(:api_url) { 'httpz://test.net/torznab/api' }
        it do
          expect { subject }.to raise_error Torznab::Client::Errors::CapsError, "Error while trying to get caps data from #{Torznab::Client.api_url}.\n"\
                                                                                "Error was 'Scheme must be either http or https'"
        end
      end
    end
  end
end
