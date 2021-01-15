RSpec.shared_examples Search::InMemory::Matcher do
  subject { instance.match(collection, query) }

  let(:collection) { [] }
  let(:query) { '' }
  let(:instance) { described_class.new }

  context 'when given an empty collection' do
    it { is_expected.to match_array([]) }
  end

  context 'when the collection has one item' do
    context 'with a single field' do
      let(:record) { { title: 'Die Hard' } }
      let(:collection) { [record] }

      context 'and searching using an emtpy string' do
        it { is_expected.to match_array(collection) }
      end

      context 'and there is a match' do
        let(:query) { 'Die' }

        it { is_expected.to match_array([record]) }
      end

      context 'and there is no match' do
        let(:query) { 'Titanic' }

        it { is_expected.to match_array([]) }
      end
    end

    context 'with multiple fields' do
      let(:record) { { title: 'Die Hard', cast: 'Bruce Willis' } }
      let(:collection) { [record] }

      context 'and searching using an emtpy string' do
        it { is_expected.to match_array(collection) }
      end

      context 'and there is a match' do
        let(:query) { 'Bruce' }

        it { is_expected.to match_array([record]) }
      end

      context 'and there is no match' do
        let(:query) { 'Smith' }

        it { is_expected.to match_array([]) }
      end
    end
  end

  context 'when the collection has many items' do
    let(:record_1) { { title: 'Die Hard' } }
    let(:record_2) { { title: 'Titanic' } }
    let(:collection) { [record_1, record_2] }

    context 'and a single field' do
      context 'and searching using an emtpy string' do
        it { is_expected.to match_array(collection) }
      end

      context 'and there is a match' do
        let(:query) { 'Die' }

        it { is_expected.to match_array([record_1]) }
      end

      context 'and there is no match' do
        let(:query) { 'Alien' }

        it { is_expected.to match_array([]) }
      end
    end

    context 'and multiple fields' do
      let(:record_1) { { title: 'Die Hard', cast: 'Bruce Willis' } }
      let(:record_2) { { title: 'Titanic', cast: 'Leonardo Dicaprio' } }
      let(:collection) { [record_1, record_2] }

      context 'and searching using an emtpy string' do
        it { is_expected.to match_array(collection) }
      end

      context 'and there is a match' do
        let(:query) { 'Leonardo' }

        it { is_expected.to match_array([record_2]) }
      end

      context 'and there is no match' do
        let(:query) { 'Demi Moore' }

        it { is_expected.to match_array([]) }
      end
    end
  end
end
