require 'spec_helper'
require 'torznab/client/caps/mappers/categories_mapper'

describe Torznab::Client::Caps::Mappers::CategoriesMapper do
  XmlError = Torznab::Client::Errors::XmlError
  Category = Torznab::Client::Caps::Category

  describe '.map' do
    before { allow(Torznab::Client::Caps::Mappers::CategoryMapper).to receive(:map).and_return Category.new }

    let(:categories_xml) do
      Nokogiri::XML::Builder.new do |xml|
        xml.searching do
          unless defined? without_category
            3.times do
              xml.category
            end
          end
        end
      end.doc.root
    end

    subject { Torznab::Client::Caps::Mappers::CategoriesMapper.map categories_xml }

    context 'when provided object is not a Nokogiri::XML::Element' do
      let(:categories_xml) { [] }
      it { expect { subject }.to raise_error XmlError, 'Provided object is not a Nokogiri::XML::Element' }
    end

    context 'when categories are empty' do
      let(:without_category) { true }
      it { is_expected.to eq [] }
    end

    context 'when categories have some children' do
      it { is_expected.to match_array [Category, Category, Category] }
    end
  end
end
