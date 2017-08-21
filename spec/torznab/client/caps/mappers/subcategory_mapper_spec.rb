require 'spec_helper'
require 'torznab/client/caps/mappers/subcategory_mapper'

XmlError = Torznab::Client::Errors::XmlError

describe Torznab::Client::Caps::Mappers::SubcategoryMapper do
  describe '.map' do
    describe 'when provided object is not a Nokogiri::XML::Element' do
      subject { Torznab::Client::Caps::Mappers::SubcategoryMapper.map [] }
      it { expect { subject }.to raise_error XmlError, 'Provided object is not a Nokogiri::XML::Element' }
    end

    let(:subcategory_hash) do
      subcategory_hash = {}
      subcategory_hash['id'] = id if defined? id
      subcategory_hash['name'] = name if defined? name
      subcategory_hash
    end

    let(:subcategory_xml_builder) do
      Nokogiri::XML::Builder.new do |xml|
        xml.subcat subcategory_hash
      end
    end

    let(:subcategory_instance) do
      subcategory_xml = Nokogiri::XML(subcategory_xml_builder.to_xml).root
      Torznab::Client::Caps::Mappers::SubcategoryMapper.map subcategory_xml
    end

    context '.id' do
      let(:name) { 'Books/Technical' }
      subject { subcategory_instance.id }

      context 'when id attribute is valid' do
        let(:id) { '8040' }
        it { is_expected.to eq 8040 }
      end

      context 'when id attribute is invalid' do
        let(:id) { 'Dummy data' }
        it { expect { subject }.to raise_error XmlError, 'Id attribute must be an integer' }
      end

      context 'when id attribute is not defined' do
        it { expect { subject }.to raise_error XmlError, 'Id attribute must be defined' }
      end
    end

    context '.name' do
      let(:id) { '8040' }
      subject { subcategory_instance.name }

      context 'when name attribute is defined' do
        let(:name) { 'Books/Technical' }
        it { is_expected.to eq 'Books/Technical' }
      end

      context 'when name attribute is not defined' do
        it { expect { subject }.to raise_error XmlError, 'Name attribute must be defined' }
      end
    end
  end
end
