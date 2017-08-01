shared_examples 'a GET request' do
  context 'with http status code 200' do
    before { stub_request(:get, url_stub_request).to_return status: 200, body: 'Body content' }
    it { is_expected.to eq 'Body content' }
  end

  [100, 300, 400, 500].each do |http_status|
    context "with http status code #{http_status}" do
      before { stub_request(:get, url_stub_request).to_return status: http_status }
      it {
        expect { subject }.to raise_error Torznab::Client::Http::HttpError,
                                          Regexp.new("Coudn't process response: #{http_status}")
      }
    end
  end
end

shared_examples 'with valid scheme' do
  let(:url_stub_request) { "#{scheme}://torznab-test.net/api" }

  context 'without ending /' do
    let(:url_get_request) { "#{scheme}://torznab-test.net" }
    include_examples 'a GET request'
  end

  context 'with ending /' do
    let(:url_get_request) { "#{scheme}://torznab-test.net/" }
    include_examples 'a GET request'
  end

  context 'with ending /api' do
    let(:url_get_request) { "#{scheme}://torznab-test.net/api" }
    include_examples 'a GET request'
  end
end
