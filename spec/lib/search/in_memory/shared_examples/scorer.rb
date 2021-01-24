RSpec.shared_examples Search::InMemory::Scorer do
  subject { instance.score(collection, query, weights) }

  let(:collection) { [] }
  let(:query) { '' }
  let(:instance) { described_class.new }
  let(:weights) { nil }

  context 'when given an empty collection' do
    it { is_expected.to match_array([]) }
  end

  context 'when the collection has one item' do
    let(:collection) { [record] }
    let(:record) { { title: 'A', _score: 1 } }

    it { is_expected.to eq([record]) }
  end
end
