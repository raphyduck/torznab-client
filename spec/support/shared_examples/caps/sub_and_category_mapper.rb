shared_examples 'a caps category or subcategory mapper' do
  describe '.id' do
    let(:name) { 'Books/Technical' }
    subject { instance.id }

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

  describe '.name' do
    let(:id) { '8040' }
    subject { instance.name }

    context 'when name attribute is defined' do
      let(:name) { 'Books/Technical' }
      it { is_expected.to eq 'Books/Technical' }
    end

    context 'when name attribute is not defined' do
      it { expect { subject }.to raise_error XmlError, 'Name attribute must be defined' }
    end
  end
end
