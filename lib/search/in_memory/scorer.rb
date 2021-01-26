module Search
  class InMemory
    module Scorer
      BASE_POWER = 10

      def score(collection, query, weights = nil)
        collection.map do |record|
          { **record, _score: record_score(record, query, weights) }
        end
      end

      def record_score(record, query, _weights = nil)
        record.reduce(0) do |total, (key, value)|
          next total unless value.is_a?(String)

          total + field_score(value, query)
        end
      end

      def field_score(value, query)
        return 0 if query.empty?
        return 1 if query == value

        start_pos = 0
        score = 0

        loop do
          start_pos = value.index(query, start_pos)
          return score unless start_pos

          score += 0.7 if start_pos == 0
          score += 0.4 if start_pos > 0

          start_pos += query.length
          return score if start_pos >= value.length
        end
      end
    end
  end
end
