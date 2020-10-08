require 'spec_helper'
require 'torznab/client/caps/mappers/categories_mapper'

describe Torznab::Caps::Mappers::CategoriesMapper do
  describe '.map' do
    before do
      category = Torznab::Caps::Category
      allow(Torznab::Caps::Mappers::CategoryMapper).to receive(:map).and_return category
    end

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

    subject { Torznab::Caps::Mappers::CategoriesMapper.map categories_xml }

    context 'when provided object is not a Nokogiri::XML::Element' do
      let(:categories_xml) { [] }
      it { expect { subject }.to raise_error Torznab::Errors::XmlError, 'Provided object is not a Nokogiri::XML::Element' }
    end

    context 'when categories are empty' do
      let(:without_category) { true }
      it { is_expected.to eq [] }
    end

    context 'when categories have some children' do
      it { is_expected.to match_array [Torznab::Caps::Category, Torznab::Caps::Category, Torznab::Caps::Category] }
    end
  end
end
