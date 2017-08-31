require 'spec_helper'
require 'torznab/client/caps/search_mode'

describe Torznab::Client::Caps::SearchMode do
  CapsError = Torznab::Client::Errors::CapsError

  let(:search) do
    search = Torznab::Client::Caps::SearchMode.new
    search.type = type if defined? type
    search.available = available if defined? available
    search.supported_params = supported_params if defined? supported_params
    search
  end

  context '#type' do
    subject { search.type }

    ['search', 'tv-search', 'movie-search'].each do |type|
      context "eq #{type}" do
        let(:type) { type }
        it { is_expected.to eq type }
      end
    end

    context 'is invalid' do
      let(:type) { 'other-search' }
      it { expect { subject }.to raise_error CapsError, 'Type must be a valid caps search type' }
    end
  end

  context '#available' do
    subject { search.available }

    [true, false].each do |available|
      context "eq #{available}" do
        let(:available) { available }
        it { is_expected.to eq available }
      end
    end

    context 'is invalid' do
      let(:available) { 'true' }
      it { expect { subject }.to raise_error CapsError, 'Available must be a boolean' }
    end
  end

  context '#supported_params' do
    subject { search.supported_params }

    context "when type isn't initialized" do
      let(:supported_params) { %w[q] }
      it { expect { subject }.to raise_error CapsError, 'Type must be initialized before setting supported_params' }
    end

    ['search', 'tv-search', 'movie-search'].each do |type|
      context "when type eq #{type}" do
        let(:type) { type }
        context 'and supported_params is valid (q)' do
          let(:supported_params) { %w[q] }
          it { is_expected.to eq %w[q] }
        end

        if type == 'tv-search'
          context 'and supported_params is valid (q,rid)' do
            let(:supported_params) { %w[q rid] }
            it { is_expected.to eq %w[q rid] }
          end
        elsif type == 'movie-search'
          context 'and supported_params is valid (q,imdbid)' do
            let(:supported_params) { %w[q imdbid] }
            it { is_expected.to eq %w[q imdbid] }
          end
        end

        context 'and supported_params is invalid with one invalid param' do
          let(:supported_params) { %w[invalid] }
          it { expect { subject }.to raise_error CapsError, 'Supported params value is invalid' }
        end

        context 'and supported_params is invalid with one invalid param and one valid param' do
          let(:supported_params) { %w[q invalid] }
          it { expect { subject }.to raise_error CapsError, 'Supported params value is invalid' }
        end

        context 'and supported_params is not defined' do
          let(:supported_params) { nil }
          if type == 'search'
            it { is_expected.to eq %w[q] }
          elsif type == 'tv-search'
            it { is_expected.to eq %w[q rid season ep] }
          elsif type == 'movie-search'
            it { is_expected.to eq %w[q] }
          end
        end
      end
    end
  end
end
