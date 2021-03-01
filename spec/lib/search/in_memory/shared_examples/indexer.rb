RSpec.shared_examples Search::InMemory::Indexer do
  subject { instance.index(collection, fields) }

  let(:collection) { [] }
  let(:instance) { described_class.new }
  let(:fields) { [:title] }

  context 'when given an empty collection' do
    it { is_expected.to eq({}) }
  end

  context 'when the collection has one item' do
    let(:collection) { [record] }
    let(:record) { { id: 1, title: 'The Matrix' } }

    it { is_expected.to eq({ 'the' => [1], 'matrix' => [1] }) }
  end

  context 'when the collection has many items' do
    let(:collection) { [record_1, record_2] }
    let(:record_1) { { id: 1, title: 'The Matrix' } }
    let(:record_2) { { id: 2, title: 'The Titanic' } }

    it { is_expected.to match_array({ 'titanic' => [2], 'the' => [1, 2], 'matrix' => [1] }) }
  end
end
