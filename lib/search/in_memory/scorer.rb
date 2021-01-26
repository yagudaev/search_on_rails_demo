module Search
  class InMemory
    module Scorer
      BASE_POWER = 10

      PERFECT_MATCH_SCORE = 1
      PARTIAL_START_MATCH_SCORE = 0.7
      PARTIAL_MATCH_SCORE = 0.4
      NO_MATCH_SCORE = 0

      def score(collection, query, weights = nil)
        collection.map do |record|
          { **record, _score: record_score(record, query, weights) }
        end
      end

      def record_score(record, query, weights = nil)
        record.reduce(0) do |total, (field, value)|
          next total unless value.is_a?(String)

          total + (weight_multiplies(weights)[field] || 1) * field_score(query, value)
        end
      end

      def field_score(query, text)
        return NO_MATCH_SCORE if query.empty?
        return PERFECT_MATCH_SCORE if query == text

        matches = find_matches(query, text)
        return NO_MATCH_SCORE if matches.empty?

        score = 0

        matches.each_with_index do |match, index|
          score += index == 0 && match == 0 ? PARTIAL_START_MATCH_SCORE : PARTIAL_MATCH_SCORE
        end

        score
      end

      private

      def find_matches(query, text)
        start_pos = 0
        matches = []

        loop do
          match = text.index(query, start_pos)
          return matches unless match

          matches << match

          start_pos = match + query.length
          return matches if start_pos >= text.length
        end
      end

      def weight_multiplies(weights)
        @weight_multiplies ||= weights&.reverse&.inject({}) do |memo, field|
          weight_factor = memo.length + 1
          memo[field] = BASE_POWER ** weight_factor
          memo
        end || {}
      end
    end
  end
end
