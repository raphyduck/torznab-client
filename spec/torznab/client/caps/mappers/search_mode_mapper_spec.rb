require 'spec_helper'
require 'torznab/client/caps/mappers/search_mode_mapper'

describe Torznab::Client::Caps::Mappers::SearchModeMapper do
  XmlError = Torznab::Client::Errors::XmlError

  describe '.map' do
    subject { Torznab::Client::Caps::Mappers::SearchModeMapper.map search_xml }

    let(:search) do
      search = instance_double 'Torznab::Client::Caps::SearchMode'
      allow(search).to receive :type=
      allow(search).to receive :available=
      allow(search).to receive :supported_params=
      allow(Torznab::Client::Caps::SearchMode).to receive(:new).and_return(search)
      search
    end

    let(:search_xml) do
      Nokogiri::XML::Builder.new do |xml|
        xml.search search_hash
      end.doc.root
    end

    context 'when provided object is not a Nokogiri::XML::Element' do
      let(:search_xml) { [] }
      it { expect { subject }.to raise_error XmlError, 'Provided object is not a Nokogiri::XML::Element' }
    end

    context 'when the name in the xml node eq some value', :end_with_subject do
      let(:search_hash) { { 'available' => 'yes' } }
      it(:test) { expect(search).to receive(:type=).with 'search' }
    end

    context 'when available attribute in the xml node' do
      context 'is not defined' do
        let(:search_hash) { {} }
        it { expect { subject }.to raise_error XmlError, 'Available attribute must be defined' }
      end

      context 'is incorrect' do
        let(:search_hash) { { 'available' => 'incorrect' } }
        it { expect { subject }.to raise_error XmlError, 'Available attribute must be either yes or no' }
      end

      context 'eq yes', :end_with_subject do
        let(:search_hash) { { 'available' => 'yes' } }
        it { expect(search).to receive(:available=).with true }
      end

      context 'eq no', :end_with_subject do
        let(:search_hash) { { 'available' => 'no' } }
        it { expect(search).to receive(:available=).with false }
      end
    end

    context 'when supportedParams attribute in the xml node' do
      context 'is not defined', :end_with_subject do
        let(:search_hash) { { 'available' => 'no' } }
        it { expect(search).to receive(:supported_params=).with nil }
      end

      context 'is defined with "param"', :end_with_subject do
        let(:search_hash) { { 'available' => 'no', 'supportedParams' => 'param' } }
        it { expect(search).to receive(:supported_params=).with %w[param] }
      end

      context 'is defined with "param,other"', :end_with_subject do
        let(:search_hash) { { 'available' => 'no', 'supportedParams' => 'param,other' } }
        it { expect(search).to receive(:supported_params=).with %w[param other] }
      end
    end
  end
end
