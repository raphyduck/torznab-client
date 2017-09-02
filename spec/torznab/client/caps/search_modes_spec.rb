require 'spec_helper'
require 'torznab/client/caps/search_modes'

describe Torznab::Client::Caps::SearchModes do
  CapsError = Torznab::Client::Errors::CapsError

  let(:search_modes) do
    search_modes = Torznab::Client::Caps::SearchModes.new
    search_modes.search = search if defined? search
    search_modes.tv_search = tv_search if defined? tv_search
    search_modes.movie_search = movie_search if defined? movie_search
    search_modes
  end

  %w[search tv_search movie_search].each do |search_mode_name|
    describe "##{search_mode_name}" do
      subject { search_modes.send search_mode_name }

      context 'when given parameter is an instance of Torznab::Client::Caps::SearchMode' do
        let(search_mode_name.to_sym) { Torznab::Client::Caps::SearchMode.new }
        it { is_expected.to eq send search_mode_name }
      end

      context 'when given parameter is not an instance of Torznab::Client::Caps::SearchMode' do
        let(search_mode_name.to_sym) { 'a string' }
        it do
          message = 'Provided search mode must be an instance of Torznab::Client::Caps::SearchMode'
          expect { subject }.to raise_error CapsError, message
        end
      end
    end
  end
end
