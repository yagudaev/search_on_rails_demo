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
  end
end
