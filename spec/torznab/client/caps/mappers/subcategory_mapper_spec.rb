require 'spec_helper'
require 'torznab/client/caps/mappers/subcategory_mapper'

describe Torznab::Caps::Mappers::SubcategoryMapper do
  describe '.map' do
    let(:category_or_subcategory_xml_builder) do
      Nokogiri::XML::Builder.new do |xml|
        xml.subcat category_or_subcategory_hash
      end
    end

    let(:category_or_subcategory_class) { Torznab::Caps::Subcategory }
    let(:category_or_subcategory_mapper_class) { Torznab::Caps::Mappers::SubcategoryMapper }
    include_examples 'a caps category or subcategory mapper'

    describe 'when the xml node is valid' do
      let(:category_or_subcategory_hash) { { 'id' => '8040', 'name' => 'Books/Technical' } }
      it { is_expected.to be_a category_or_subcategory_class }
      it { expect(subject.id).to eq 8040 }
      it { expect(subject.name).to eq 'Books/Technical' }
    end
  end
end
