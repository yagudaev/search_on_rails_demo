require 'rails_helper'
require 'lib/search/in_memory/shared_examples/matcher'
require 'lib/search/in_memory/shared_examples/highlighter'

RSpec.describe Search::InMemory do
  it_behaves_like Search::InMemory::Matcher
  it_behaves_like Search::InMemory::Highlighter

  # combines all
  # describe '.search' do
  #   subject { instance.search(collection, query) }

  #   let(:collection) { [] }
  #   let(:query) { '' }
  #   let(:instance) { described_class.new }

  # end
end
