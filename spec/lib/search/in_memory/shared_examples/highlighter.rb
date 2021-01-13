RSpec.shared_examples Search::InMemory::Highlighter do
  subject { instance.highlight(collection, query) }

  let(:collection) { [] }
  let(:query) { '' }
  let(:instance) { described_class.new }

  context 'when given an empty collection' do
    it { is_expected.to match_array([]) }
  end

  context 'when the collection has one or more items' do
    subject { super().first[:title] }

    context 'with a single field' do
      let(:record) { { title: 'Die Hard' } }
      let(:collection) { [record] }

      context 'and searching using an empty string' do
        it('has no highlights') { is_expected.to eq('Die Hard') }
      end

      context 'and there is a match' do
        let(:query) { 'Die' }

        it { is_expected.to eq('<b>Die</b> Hard') }
      end

      context 'and there is no match' do
        let(:query) { 'Titanic' }

        it { is_expected.to eq('Die Hard') }
      end
    end

    # context 'with multiple fields' do
    #   let(:record) { { title: 'Die Hard', cast: 'Bruce Willis' } }
    #   let(:collection) { [record] }

    #   context 'and searching using an emtpy string' do
    #     it { is_expected.to match_array(collection) }
    #   end

    #   context 'and there is a match' do
    #     let(:query) { 'Bruce' }

    #     it { is_expected.to match_array([record]) }
    #   end

    #   context 'and there is no match' do
    #     let(:query) { 'Smith' }

    #     it { is_expected.to match_array([]) }
    #   end
    # end

    # this is a searchable fields feature, maybe structure the tests a little different?
    # context 'and multiple fields including none-searchable ones' do
    #   let(:record) { { title: 'Die Hard', cast: 'Bruce Willis', description: 'Great movie' } }
    #   let(:collection) { [record] }
    #   let(:instance) { described_class.new(searchable_fields: %i[title cast]) }

    #   context 'and searching using an emtpy string' do
    #     it { is_expected.to match_array(collection) }
    #   end

    #   context 'and there is a match' do
    #     let(:query) { 'Bruce' }

    #     it { is_expected.to match_array([record]) }
    #   end

    #   context 'and there is no match' do
    #     let(:query) { 'Great' }

    #     it { is_expected.to match_array([]) }
    #   end
    # end
  end
end
