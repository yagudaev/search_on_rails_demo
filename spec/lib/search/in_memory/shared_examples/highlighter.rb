RSpec.shared_examples Search::InMemory::Highlighter do
  subject { instance.highlight(collection, query) }

  let(:collection) { [] }
  let(:query) { '' }
  let(:instance) { described_class.new }

  context 'when given an empty collection' do
    it { is_expected.to match_array([]) }
  end

  context 'when the collection has one or more items' do
    context 'with a single field' do
      subject { super().first[:title] }

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

    context 'with a nil field value' do
      subject { super().first[:title] }

      let(:query) { 'Titanic' }
      let(:record) { { title: nil } }
      let(:collection) { [record] }

      it { is_expected.to be_nil }
    end

    context 'with multiple fields' do
      let(:record) { { title: 'Die Hard', cast: 'Bruce Willis' } }
      let(:collection) { [record] }

      context 'and searching using an emtpy string' do
        subject { super().first }

        it { expect(subject[:title]).to eq('Die Hard') }
        it { expect(subject[:cast]).to eq('Bruce Willis') }
      end

      context 'and there is a match' do
        subject { super().first[:cast] }

        let(:query) { 'Bruce' }

        it { is_expected.to eq('<b>Bruce</b> Willis') }
      end

      context 'and there is no match' do
        subject { super().first[:cast] }

        let(:query) { 'Smith' }

        it { is_expected.to eq('Bruce Willis') }
      end
    end
  end
end
