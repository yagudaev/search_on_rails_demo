RSpec.shared_examples Search::InMemory::Sorter do
  subject { instance.sort(collection, query, sort) }

  let(:collection) { [] }
  let(:query) { '' }
  let(:instance) { described_class.new }
  let(:sort) { nil }

  context 'when given an empty collection' do
    it { is_expected.to match_array([]) }
  end

  context 'when the collection has one item' do
    let(:collection) { [record] }
    let(:record) { { title: 'A' } }

    it { is_expected.to eq([record]) }
  end

  context 'when the collection has many items' do
    let(:collection) { [record_1, record_2, record_3] }
    let(:record_1) { { title: 'B' } }
    let(:record_2) { { title: 'A' } }
    let(:record_3) { { title: 'C' } }

    it { is_expected.to eq([record_1, record_2, record_3]) }

    describe 'and sorting by ascending order' do
      let(:sort) { { field: 'title', direction: 'ascending' } }

      it { is_expected.to eq([record_2, record_1, record_3]) }
    end

    describe 'and sorting by descending order' do
      let(:sort) { { field: 'title', direction: 'descending' } }

      it { is_expected.to eq([record_3, record_1, record_2]) }
    end
  end
end
