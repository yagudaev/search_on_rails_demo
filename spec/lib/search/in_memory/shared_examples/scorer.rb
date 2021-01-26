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

    context 'when full match' do
      it { is_expected.to eq([{ **record, _score: 1 }]) }
    end

    context 'when partial match start' do
      let(:record) { { title: 'Matrix: Reloaded' } }

      it { is_expected.to eq([{ **record, _score: 0.7 }]) }
    end

    context 'when partial match middle or end' do
      let(:record) { { title: 'The Matrix: Reloaded' } }

      it { is_expected.to eq([{ **record, _score: 0.4 }]) }
    end

    context 'when multiple partial matches on same field' do
      let(:record) { { title: 'Matrix multipied by another Matrix' } }

      it { is_expected.to eq([{ **record, _score: 1.1 }]) }
    end

    context 'when no match' do
      let(:record) { { title: 'Something Else' } }

      it { is_expected.to eq([{ **record, _score: 0 }]) }
    end

    context 'when the query is empty' do
      let(:query) { '' }

      it { is_expected.to eq([{ **record, _score: 0 }]) }
    end

    context 'when one weight is provided' do
      let(:weights) { [:title] }
      let(:record) { { title: 'The Matrix', cast: 'Keenu Reeves' } }
      let(:query) { 'The Matrix' }

      it { is_expected.to eq([{ **record, _score: 10 }]) }
    end
  end

  context 'when the collection has multiple items' do
    let(:collection) { [record_1, record_2] }
    let(:record_1) { { title: 'Matrix' } }
    let(:record_2) { { title: 'Titanic' } }
    let(:query) { 'Matrix' }

    context 'when full match' do
      it { is_expected.to eq([{ **record_1, _score: 1 }, { **record_2, _score: 0 }]) }
    end
  end

  # weights for fields power


  # position based pass in the match locations

end
