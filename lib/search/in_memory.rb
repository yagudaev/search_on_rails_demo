module Search
  class InMemory
    include Matcher

    def search(records, query_string)
      match(records, query_string)
    end
  end
end
