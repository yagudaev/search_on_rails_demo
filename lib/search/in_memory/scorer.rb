module Search
  class InMemory
    module Scorer
      BASE_POWER = 10

      def score(collection, query, _weights = nil)
        collection.map do |record|
          total_score = record.reduce(0) do |total, (key, value)|
            next total unless value.is_a?(String)

            total + field_score(value, query)
          end
          { **record, _score: total_score }
        end
      end

      def field_score(value, query)
        return 1 if query == value

        pos = value.index(query)
        return 0 unless pos
        return 0.7 if pos == 0

        0.4
      end
    end
  end
end
