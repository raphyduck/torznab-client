require 'spec_helper'
require 'torznab/client/caps/category'

describe Torznab::Client::Caps::Category do
  CapsError = Torznab::Client::Errors::CapsError

  let(:subcategory) do
    subcategory = Torznab::Client::Caps::Category.new
    subcategory.id = id if defined? id
    subcategory.name = name if defined? name
    subcategory.subcategories = subcategories if defined? subcategories
    subcategory
  end

  include_examples 'a caps category or subcategory'

  describe '.subcategories' do
    subject { subcategory.subcategories }

    context 'when valid' do
      let(:subcategories) { [Torznab::Client::Caps::Subcategory.new, Torznab::Client::Caps::Subcategory.new] }
      it { is_expected.to eq subcategories }
    end

    context 'when it is not an array' do
      let(:subcategories) { '8040' }
      it { expect { subject }.to raise_error CapsError, 'Subcategories must be an array' }
    end

    context 'when it is not an array composed only with Subcategory objects' do
      let(:subcategories) { [Torznab::Client::Caps::Subcategory.new, 'a string'] }
      it { expect { subject }.to raise_error CapsError, 'Subcategories must be composed only of Subcategory objects' }
    end
  end
end
