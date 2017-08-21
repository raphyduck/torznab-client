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

    let(:instance) do
      subcategory_xml = Nokogiri::XML(subcategory_xml_builder.to_xml).root
      Torznab::Client::Caps::Mappers::SubcategoryMapper.map subcategory_xml
    end

    include_examples 'a caps category or subcategory mapper'
  end
end
