module Search
  class InMemory
    def search(records, query_string)
      match(records, query_string)
    end

    def match(records, query_string)
      records.select do |r|
        r.keys.any? { |key| match_by_word(r[key], query_string) }
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
