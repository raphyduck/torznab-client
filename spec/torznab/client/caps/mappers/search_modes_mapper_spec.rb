require 'spec_helper'
require 'torznab/client/caps/mappers/search_modes_mapper'

describe Torznab::Caps::Mappers::SearchModesMapper do
  describe '.map' do
    before do
      search_mode = Torznab::Caps::SearchMode.new
      allow(Torznab::Caps::Mappers::SearchModeMapper).to receive(:map).and_return search_mode
    end
    let(:search_modes) do
      search_modes = instance_double 'Torznab::Caps::SearchModes'
      allow(search_modes).to receive :search=
      allow(search_modes).to receive :tv_search=
      allow(search_modes).to receive :movie_search=
      allow(Torznab::Caps::SearchModes).to receive(:new).and_return(search_modes)
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

    subject { Torznab::Caps::Mappers::SearchModesMapper.map search_modes_xml }

    context 'when provided object is not a Nokogiri::XML::Element' do
      let(:search_modes_xml) { [] }
      it { expect { subject }.to raise_error Torznab::Errors::XmlError, 'Provided object is not a Nokogiri::XML::Element' }
    end

    context 'when the search node is missing from the searching node' do
      let(:without_search) { true }
      it { expect { subject }.to raise_error Torznab::Errors::XmlError, 'Search mode with name search must exist' }
    end

    context 'when the search node is missing from the searching node' do
      let(:without_tv_search) { true }
      it { expect { subject }.to raise_error Torznab::Errors::XmlError, 'Search mode with name tv-search must exist' }
    end

    context 'when the search node is missing from the searching node' do
      let(:without_movie_search) { true }
      it { expect { subject }.to raise_error Torznab::Errors::XmlError, 'Search mode with name movie-search must exist' }
    end

    context 'when all the required search nodes are in the searching node', :end_with_subject do
      it { expect(search_modes).to receive(:search=).with instance_of Torznab::Caps::SearchMode }
      it { expect(search_modes).to receive(:tv_search=).with instance_of Torznab::Caps::SearchMode }
      it { expect(search_modes).to receive(:movie_search=).with instance_of Torznab::Caps::SearchMode }
    end
  end
end
