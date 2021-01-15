require 'rails_helper'
require 'lib/search/in_memory/shared_examples/matcher'

RSpec.describe Search::InMemory do
  it_behaves_like Search::InMemory::Matcher
end
