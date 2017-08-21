require 'spec_helper'
require 'torznab/client/caps/mappers/category_mapper'

Subcategory = Torznab::Client::Caps::Subcategory
XmlError = Torznab::Client::Errors::XmlError

describe Torznab::Client::Caps::Mappers::CategoryMapper do
  describe '.map' do
    describe 'when provided object is not a Nokogiri::XML::Element' do
      subject { Torznab::Client::Caps::Mappers::CategoryMapper.map [] }
      it { expect { subject }.to raise_error XmlError, 'Provided object is not a Nokogiri::XML::Element' }
    end

    before { allow(Torznab::Client::Caps::Mappers::SubcategoryMapper).to receive(:map).and_return Subcategory.new }

    let(:category_hash) do
      category_hash = {}
      category_hash['id'] = id if defined? id
      category_hash['name'] = name if defined? name
      category_hash
    end

    let(:category_xml_builder) do
      Nokogiri::XML::Builder.new do |xml|
        xml.category category_hash do
          if defined? with_subcats
            3.times do
              xml.subcat
            end
          end
        end
      end
    end

    let(:instance) do
      category_xml = Nokogiri::XML(category_xml_builder.to_xml).root
      Torznab::Client::Caps::Mappers::CategoryMapper.map category_xml
    end

    include_examples 'a caps category or subcategory mapper'

    context '.subcategories' do
      let(:name) { 'Books/Technical' }
      let(:id) { '8040' }
      subject { instance.subcategories }

      context 'when no subcategories are present' do
        it { is_expected.to eq [] }
      end

      context 'when some subcategories are present' do
        let(:with_subcats) { true }
        it { is_expected.to all(be_an(Subcategory)) }
        it 'length should eq 3 for 3 subcats' do
          expect(subject.length).to eq 3
        end
      end
    end
  end
end
