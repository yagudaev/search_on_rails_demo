RSpec.shared_examples Search::InMemory::Faceter do
  subject { instance.facets(collection, query, { facets: facets }) }

  let(:collection) { [] }
  let(:instance) { described_class.new }
  let(:facets) { [:type] }
  let(:query) { '' }

  context 'when given an empty collection' do
    it { is_expected.to match_array([{ field: "type", items: [], label: "Type" }]) }
  end

  context 'when the collection has one item' do
    let(:collection) { [record] }
    let(:record) { { type: 'Movie' } }

    it { is_expected.to eq([{ label: 'Type', field: 'type', items: [{ label: 'Movie', value: 'Movie', count: 1 }] }]) }
  end

  context 'when the collection has many items' do
    let(:collection) { [record_1, record_2] }
    let(:record_1) { { type: 'Movie' } }
    let(:record_2) { { type: 'TV-Show' } }

    let(:expected_items) do
      [
        { label: 'Movie', value: 'Movie', count: 1 },
        { label: 'TV-Show', value: 'TV-Show', count: 1 }
      ]
    end

    it { is_expected.to eq([{ label: 'Type', field: 'type', items: expected_items }]) }
  end

  # TODO: check it works with both strings and symbol keys
  # TODO: empty values
  # TODO: sorting count

  # TODO: with a query

end
