require 'rails_helper'
require 'lib/search/in_memory/shared_examples/matching'

RSpec.describe Search::InMemory do
  it_behaves_like 'matcher'

  describe '.search' do
    subject { instance.search(collection, query) }

    let(:collection) { [] }
    let(:query) { '' }
    let(:instance) { described_class.new }

  end
end
