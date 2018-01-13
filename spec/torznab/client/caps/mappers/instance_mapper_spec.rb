require 'spec_helper'
require 'torznab/client/caps/mappers/instance_mapper'
require 'torznab/client/caps/mappers/search_modes_mapper'
require 'torznab/client/caps/mappers/categories_mapper'

describe Torznab::Client::Caps::Mappers::InstanceMapper do
  describe '.map' do
    before do
      search_modes = Torznab::Client::Caps::SearchModes.new
      allow(Torznab::Client::Caps::Mappers::SearchModesMapper).to receive(:map).and_return search_modes
    end
    before { allow(Torznab::Client::Caps::Mappers::CategoriesMapper).to receive(:map).and_return [] }

    let(:caps_instance) do
      caps_instance = instance_double 'Torznab::Client::Caps::Instance'
      allow(caps_instance).to receive :search_modes=
      allow(caps_instance).to receive :categories=
      allow(Torznab::Client::Caps::Instance).to receive(:new).and_return(caps_instance)
      caps_instance
    end

    let(:caps_xml) do
      Nokogiri::XML::Builder.new do |xml|
        xml.caps do
          xml.searching unless defined? without_searching
          xml.categories unless defined? without_categories
        end
      end.doc.root
    end

    subject { Torznab::Client::Caps::Mappers::InstanceMapper.map caps_xml }

    context 'when provided object is not a Nokogiri::XML::Element' do
      let(:caps_xml) { [] }
      it { expect { subject }.to raise_error Torznab::Client::Errors::XmlError, 'Provided object is not a Nokogiri::XML::Element' }
    end

    context 'when the searching node is missing from the searching node' do
      let(:without_searching) { true }
      it { expect { subject }.to raise_error Torznab::Client::Errors::XmlError, 'Searching node must be defined' }
    end

    context 'when the categories node is missing from the searching node' do
      let(:without_categories) { true }
      it { expect { subject }.to raise_error Torznab::Client::Errors::XmlError, 'Categories node must be defined' }
    end

    context 'when all the required nodes are in the caps node', :end_with_subject do
      it { expect(caps_instance).to receive(:search_modes=).with instance_of Torznab::Client::Caps::SearchModes }
      it { expect(caps_instance).to receive(:categories=).with instance_of Array }
    end
  end
end
