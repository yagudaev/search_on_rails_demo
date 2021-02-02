RSpec.shared_examples Search::InMemory::Filter do
  subject { instance.filter(collection, filters) }

  let(:collection) { [] }
  let(:instance) { described_class.new }
  let(:filters) { { type: ['Movie'] } }

  context 'when given an empty collection' do
    it { is_expected.to match_array([]) }
  end

  context 'when the collection has one item' do
    let(:collection) { [record] }
    let(:record) { { type: 'Movie' } }

    it { is_expected.to match_array([record]) }
  end

  context 'when the collection has many items' do
    let(:collection) { [record_1, record_2] }
    let(:record_1) { { type: 'Movie' } }
    let(:record_2) { { type: 'TV-Show' } }

    it { is_expected.to match_array([record_1]) }
  end

  # TODO: check it works with both strings and symbol keys
  # TODO: empty values
  # TODO: sorting count

end
