require 'spec_helper'
require 'torznab/client/caps/search_modes'

describe Torznab::Caps::SearchModes do
  let(:search_modes) do
    search_modes = Torznab::Caps::SearchModes.new
    search_modes.search = search if defined? search
    search_modes.tv_search = tv_search if defined? tv_search
    search_modes.movie_search = movie_search if defined? movie_search
    search_modes
  end

  %w[search tv_search movie_search].each do |search_mode_name|
    describe "##{search_mode_name}" do
      subject { search_modes.send search_mode_name }

      context 'when given parameter is an instance of Torznab::Caps::SearchMode' do
        let(search_mode_name.to_sym) { Torznab::Caps::SearchMode.new }
        it { is_expected.to eq send search_mode_name }
      end

      context 'when given parameter is not an instance of Torznab::Caps::SearchMode' do
        let(search_mode_name.to_sym) { 'a string' }
        it do
          message = 'Provided search mode must be an instance of Torznab::Caps::SearchMode'
          expect { subject }.to raise_error Torznab::Errors::CapsError, message
        end
      end
    end
  end
end
