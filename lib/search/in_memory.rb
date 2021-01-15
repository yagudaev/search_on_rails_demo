module Search
  class InMemory
    def search(records, query_string)
      match(records, query_string)
    end

    def match(records, query_string)
      records
    end
  end
end
