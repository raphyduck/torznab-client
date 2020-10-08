shared_examples 'a caps category or subcategory mapper' do
  let(:category_or_subcategory_xml) { Nokogiri::XML(category_or_subcategory_xml_builder.to_xml).root }
  subject { category_or_subcategory_mapper_class.map category_or_subcategory_xml }

  describe 'when provided object is not a Nokogiri::XML::Element' do
    let(:category_or_subcategory_xml) { [] }
    it { expect { subject }.to raise_error Torznab::Errors::XmlError, 'Provided object is not a Nokogiri::XML::Element' }
  end

  describe 'when id in the xml node' do
    describe 'is not defined' do
      let(:category_or_subcategory_hash) { { 'name' => 'Books/Technical' } }
      it { expect { subject }.to raise_error Torznab::Errors::XmlError, 'Id attribute must be defined' }
    end

    describe 'does not have an integer format' do
      let(:category_or_subcategory_hash) { { 'id' => 'Wrong id', 'name' => 'Books/Technical' } }
      it { expect { subject }.to raise_error Torznab::Errors::XmlError, 'Id attribute format must be an integer' }
    end
  end

  describe 'when name in the xml node is not defined' do
    let(:category_or_subcategory_hash) { { 'id' => '8040' } }
    it { expect { subject }.to raise_error Torznab::Errors::XmlError, 'Name attribute must be defined' }
  end
end
