require 'spec_helper'
require 'torznab/client/caps/instance'

describe Torznab::Caps::Instance do
  let(:caps) do
    caps = Torznab::Caps::Instance.new
    caps.search_modes = search_modes if defined? search_modes
    caps.categories = categories if defined? categories
    caps
  end

  describe '.search_modes' do
    subject { caps.search_modes }

    context 'when valid' do
      let(:search_modes) { Torznab::Caps::SearchModes.new }
      it { is_expected.to eq search_modes }
    end

    context 'when invalid' do
      let(:search_modes) { 'a string' }
      it { expect { subject }.to raise_error Torznab::Errors::CapsError, 'Search_modes must be a SearchModes instance' }
    end
  end

  describe '.categories' do
    subject { caps.categories }

    context 'when valid' do
      let(:categories) { [Torznab::Caps::Category.new, Torznab::Caps::Category.new] }
      it { is_expected.to eq categories }
    end

    context 'when it is not an array' do
      let(:categories) { '8040' }
      it { expect { subject }.to raise_error Torznab::Errors::CapsError, 'Categories must be an array' }
    end

    context 'when it is not an array composed only with Category objects' do
      let(:categories) { [Torznab::Caps::Category.new, 'a string'] }
      it { expect { subject }.to raise_error Torznab::Errors::CapsError, 'Categories must be composed only of instances of Category' }
    end
  end
end
