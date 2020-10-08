require 'spec_helper'
require 'torznab/client/caps/mappers/search_mode_mapper'

describe Torznab::Caps::Mappers::SearchModeMapper do
  describe '.map' do
    let(:search_mode) do
      search_mode = instance_double 'Torznab::Caps::SearchMode'
      allow(search_mode).to receive :type=
      allow(search_mode).to receive :available=
      allow(search_mode).to receive :supported_params=
      allow(Torznab::Caps::SearchMode).to receive(:new).and_return(search_mode)
      search_mode
    end

    let(:search_mode_xml) do
      Nokogiri::XML::Builder.new do |xml|
        xml.search search_mode_hash
      end.doc.root
    end

    subject { Torznab::Caps::Mappers::SearchModeMapper.map search_mode_xml }

    context 'when provided object is not a Nokogiri::XML::Element' do
      let(:search_mode_xml) { [] }
      it { expect { subject }.to raise_error Torznab::Errors::XmlError, 'Provided object is not a Nokogiri::XML::Element' }
    end

    context 'when the name in the xml node eq some value', :end_with_subject do
      let(:search_mode_hash) { { 'available' => 'yes' } }
      it { expect(search_mode).to receive(:type=).with 'search' }
    end

    context 'when available attribute in the xml node' do
      context 'is not defined' do
        let(:search_mode_hash) { {} }
        it { expect { subject }.to raise_error Torznab::Errors::XmlError, 'Available attribute must be defined' }
      end

      context 'is incorrect' do
        let(:search_mode_hash) { { 'available' => 'incorrect' } }
        it { expect { subject }.to raise_error Torznab::Errors::XmlError, 'Available attribute must be either yes or no' }
      end

      context 'eq yes', :end_with_subject do
        let(:search_mode_hash) { { 'available' => 'yes' } }
        it { expect(search_mode).to receive(:available=).with true }
      end

      context 'eq no', :end_with_subject do
        let(:search_mode_hash) { { 'available' => 'no' } }
        it { expect(search_mode).to receive(:available=).with false }
      end
    end

    context 'when supportedParams attribute in the xml node' do
      context 'is not defined', :end_with_subject do
        let(:search_mode_hash) { { 'available' => 'no' } }
        it { expect(search_mode).to receive(:supported_params=).with nil }
      end

      context 'is defined with "param"', :end_with_subject do
        let(:search_mode_hash) { { 'available' => 'no', 'supportedParams' => 'param' } }
        it { expect(search_mode).to receive(:supported_params=).with %w[param] }
      end

      context 'is defined with "param,other"', :end_with_subject do
        let(:search_mode_hash) { { 'available' => 'no', 'supportedParams' => 'param,other' } }
        it { expect(search_mode).to receive(:supported_params=).with %w[param other] }
      end
    end
  end
end
