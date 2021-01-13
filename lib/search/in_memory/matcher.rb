module Search
  class InMemory
    module Matcher
      def match(records, query_string, searchable_fields = nil)
        records.select do |r|
          keys = searchable_fields || r.keys
          keys.any? { |key| match_by_word(r[key], query_string) }
        end
      end

      private

      def match_by_word(test_string, query_string)
        return true if query_string.blank?
        return false if test_string.blank?

        query_string.split.any? { |word| test_string.include?(word) }
      end
    end
  end
end
