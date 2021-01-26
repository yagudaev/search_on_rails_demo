RSpec.shared_examples Search::InMemory::Scorer do
  subject { instance.score(collection, query, weights) }

  let(:collection) { [] }
  let(:query) { '' }
  let(:instance) { described_class.new }
  let(:weights) { nil }

  context 'when given an empty collection' do
    it { is_expected.to match_array([]) }
  end

  context 'when the collection has one item and a match' do
    let(:collection) { [record] }
    let(:record) { { title: 'Matrix' } }
    let(:query) { 'Matrix' }

    describe 'full match' do
      it { is_expected.to eq([{ **record, _score: 1 }]) }
    end

    describe 'partial match start' do
      let(:record) { { title: 'Matrix: Reloaded' } }

      it { is_expected.to eq([{ **record, _score: 0.7 }]) }
    end

    describe 'partial match middle or end' do
      let(:record) { { title: 'The Matrix: Reloaded' } }

      it { is_expected.to eq([{ **record, _score: 0.4 }]) }
    end

    describe 'no match' do
      let(:record) { { title: 'Something Else' } }

      it { is_expected.to eq([{ **record, _score: 0 }]) }
    end
  end

  # weights for fields power
  # full-match ratio 1  10
  # start partial-match 0.7 * 10^(weight)
  # middle/end partial match 0.4 * 10^(weight)
  # multiple matches

  # position based pass in the match locations

  # fuzzy-match ?
end
