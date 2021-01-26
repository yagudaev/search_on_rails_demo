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

    describe 'multiple partial matches on same field' do
      let(:record) { { title: 'Matrix multipied by another Matrix' } }

      it { is_expected.to eq([{ **record, _score: 1.1 }]) }
    end

    describe 'no match' do
      let(:record) { { title: 'Something Else' } }

      it { is_expected.to eq([{ **record, _score: 0 }]) }
    end

    describe 'when the query is empty' do
      let(:query) { '' }

      it { is_expected.to eq([{ **record, _score: 0 }]) }
    end
  end

  # weights for fields power


  # position based pass in the match locations

end
