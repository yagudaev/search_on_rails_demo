module Search
  class InMemory
    include Matcher
    include Highlighter

    def search(records, query)
      query_string = remove_stop_words(query)
      results = records.map(&:with_indifferent_access)

      results = match(results, query_string)
      results = highlight(results, query_string)

      results
    end

    private

    def remove_stop_words(str)
      str.gsub(/\b(the|a|an|of|to)\b/, '')
    end

    def self.add_score(results)
      # highest if found in title > cast | 10^2 (100), 10^1 (10)
      # full word > partial word  | 5 & 2
      # start of text > middle of text > end of text | 3, 2, 1
      results.each do |result|
        result['_score'] = 10**2
      end
    end
  end
end
