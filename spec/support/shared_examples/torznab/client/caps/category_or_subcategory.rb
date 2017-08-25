shared_examples 'a caps category or subcategory' do
  describe '.id' do
    subject { subcategory.id }

    context 'when valid' do
      let(:id) { 8040 }
      it { is_expected.to eq 8040 }
    end

    context 'when it is not an integer' do
      let(:id) { '8040' }
      it { expect { subject }.to raise_error CapsError, 'Id must be an integer' }
    end
  end

  describe '.name' do
    subject { subcategory.name }

    context 'when valid' do
      let(:name) { 'Books/Technical' }
      it { is_expected.to eq 'Books/Technical' }
    end

    context 'when it is not a string' do
      let(:name) { 8040 }
      it { expect { subject }.to raise_error CapsError, 'Name must be a string' }
    end
  end
end
