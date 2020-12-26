require 'rails_helper'

RSpec.describe Search::InMemory do
  describe '.search' do
    let(:collection) { [] }
    let(:query) { '' }
    subject { described_class.search(collection, query) }

    context 'when given an empty collection' do
      it { is_expected.to match_array([]) }
    end

    context 'when the collection has one item' do
      let(:record) { { title: 'Die Hard', description: 'Great movie' } }
      let(:collection) { [record] }

      context 'and searching using an emtpy string' do
        it { is_expected.to match_array(collection) }
      end

      context 'and there is a match' do
        let(:query) { 'Die' }
        it { is_expected.to match_array([record]) }
      end

      context 'and there is no match' do
        let(:query) { 'Titanic' }
        it { is_expected.to match_array([]) }
      end
    end

    context 'when the collection has many items' do
      let(:record_1) { { title: 'Die Hard', description: 'Great movie' } }
      let(:record_2) { { title: 'Titanic', description: 'Sad movie' } }
      let(:collection) { [record_1, record_2] }

      context 'and searching using an emtpy string' do
        it { is_expected.to match_array(collection) }
      end

      context 'and there is a match' do
        let(:query) { 'Die' }
        it { is_expected.to match_array([record_1]) }
      end

      context 'and there is no match' do
        let(:query) { 'Alien' }
        it { is_expected.to match_array([]) }
      end
    end
  end
end
