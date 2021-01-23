RSpec.shared_examples Search::InMemory::Sorter do
  subject { instance.sort(collection, query) }

  let(:collection) { [] }
  let(:query) { '' }
  let(:instance) { described_class.new }

  context 'when given an empty collection' do
    it { is_expected.to match_array([]) }
  end

  context 'when the collection has one or more items' do
  end
end
