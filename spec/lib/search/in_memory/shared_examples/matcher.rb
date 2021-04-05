RSpec.shared_examples Search::InMemory::Matcher do
  subject { instance.match(collection, query) }

  let(:collection) { [] }
  let(:query) { '' }
  let(:instance) { described_class.new }

  context 'when given an empty collection' do
    it { is_expected.to match_array([]) }
  end

  context 'when given a collection with one item' do
    let(:collection) { [record] }

    describe 'with a single field' do
      let(:record) { { title: 'The Matrix' } }

      it { is_expected.to match_array([record]) }

      context 'and there is a match' do
        let(:query) { 'The Matrix' }

        it { is_expected.to match_array([record]) }
      end

      context 'and there is a lower case match' do
        let(:query) { 'the matrix' }

        it { is_expected.to match_array([record]) }
      end

      context 'and there is no match' do
        let(:query) { 'Titanic' }

        it { is_expected.to match_array([]) }
      end
    end

    describe 'with a nil field' do
      let(:record) { { title: 'The Matrix', cast: nil } }

      it { is_expected.to match_array([record]) }

      context 'and there is a match' do
        let(:query) { 'The Matrix' }

        it { is_expected.to match_array([record]) }
      end

      context 'and there is no match' do
        let(:query) { 'Titanic' }

        it { is_expected.to match_array([]) }
      end
    end

    describe 'with multiple fields' do
      let(:record) { { title: 'The Matrix', cast: 'Keanu Reeves' } }

      it { is_expected.to match_array([record]) }

      context 'and there is a match' do
        let(:query) { 'Keanu Reeves' }

        it { is_expected.to match_array([record]) }
      end

      context 'and there is no match' do
        let(:query) { 'Bruce Willis' }

        it { is_expected.to match_array([]) }
      end
    end
  end

  context 'when given a collection with many items' do
    let(:collection) { [record_1, record_2] }
    let(:record_1) { { title: 'The Matrix', cast: 'Keanu Reeves' } }
    let(:record_2) { { title: 'Titanic', cast: 'Leonardo DiCaprio' } }

    it { is_expected.to match_array([record_1, record_2]) }

    context 'and there is a match' do
      let(:query) { 'Keanu Reeves' }

      it { is_expected.to match_array([record_1]) }
    end

    context 'and there is a partial match' do
      let(:query) { 'Keanu' }

      it { is_expected.to match_array([record_1]) }
    end

    context 'and there is no match' do
      let(:query) { 'Bruce Willis' }

      it { is_expected.to match_array([]) }
    end
  end
end
