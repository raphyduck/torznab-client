require 'spec_helper'
require 'torznab/client/caps/mappers/search_modes_mapper'

describe Torznab::Client::Caps::Mappers::SearchModesMapper do
  XmlError = Torznab::Client::Errors::XmlError
  SearchMode = Torznab::Client::Caps::SearchMode

  describe '.map' do
    before { allow(Torznab::Client::Caps::Mappers::SearchModeMapper).to receive(:map).and_return SearchMode.new }

    let(:search_modes) do
      search_modes = instance_double 'Torznab::Client::Caps::SearchModes'
      allow(search_modes).to receive :search=
      allow(search_modes).to receive :tv_search=
      allow(search_modes).to receive :movie_search=
      allow(Torznab::Client::Caps::SearchModes).to receive(:new).and_return(search_modes)
      search_modes
    end

    let(:search_modes_xml) do
      Nokogiri::XML::Builder.new do |xml|
        xml.searching do
          xml.send 'search' unless defined? without_search
          xml.send :'tv-search' unless defined? without_tv_search
          xml.send :'movie-search' unless defined? without_movie_search
        end
      end.doc.root
    end

    subject { Torznab::Client::Caps::Mappers::SearchModesMapper.map search_modes_xml }

    context 'when provided object is not a Nokogiri::XML::Element' do
      let(:search_modes_xml) { [] }
      it { expect { subject }.to raise_error XmlError, 'Provided object is not a Nokogiri::XML::Element' }
    end

    context 'when the search node is missing from the searching node' do
      let(:without_search) { true }
      it { expect { subject }.to raise_error XmlError, 'Search mode with name search must exist' }
    end

    context 'when the search node is missing from the searching node' do
      let(:without_tv_search) { true }
      it { expect { subject }.to raise_error XmlError, 'Search mode with name tv-search must exist' }
    end

    context 'when the search node is missing from the searching node' do
      let(:without_movie_search) { true }
      it { expect { subject }.to raise_error XmlError, 'Search mode with name movie-search must exist' }
    end

    context 'when all the required search nodes are in the searching node', :end_with_subject do
      it { expect(search_modes).to receive(:search=).with instance_of SearchMode }
      it { expect(search_modes).to receive(:tv_search=).with instance_of SearchMode }
      it { expect(search_modes).to receive(:movie_search=).with instance_of SearchMode }
    end
  end
end
