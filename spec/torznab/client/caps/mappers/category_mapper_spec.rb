require 'spec_helper'
require 'torznab/client/caps/mappers/category_mapper'

describe Torznab::Client::Caps::Mappers::CategoryMapper do
  Subcategory = Torznab::Client::Caps::Subcategory

  describe '.map' do
    before { allow(Torznab::Client::Caps::Mappers::SubcategoryMapper).to receive(:map).and_return Subcategory.new }

    let(:category_or_subcategory_xml_builder) do
      Nokogiri::XML::Builder.new do |xml|
        xml.category category_or_subcategory_hash do
          3.times do
            xml.subcat
          end
        end
      end
    end

    let(:category_or_subcategory_class) { Torznab::Client::Caps::Category }
    let(:category_or_subcategory_mapper_class) { Torznab::Client::Caps::Mappers::CategoryMapper }
    include_examples 'a caps category or subcategory mapper'

    describe 'when the xml node is valid' do
      let(:category_or_subcategory_hash) { { 'id' => '8040', 'name' => 'Books/Technical' } }
      it { is_expected.to be_a category_or_subcategory_class }
      it { expect(subject.id).to eq 8040 }
      it { expect(subject.name).to eq 'Books/Technical' }
      it { expect(subject.subcategories.length).to eq 3 }
    end
  end
end
