module Search
  class InMemory
    module Scorer
      def score(collection, _query, _weights = nil)
        collection.map do |record|
          { **record, _score: 1 }
        end
      end
    end
  end
end
