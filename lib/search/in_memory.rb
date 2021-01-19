module Search
  class InMemory
    def search(records, query_string)
      match(records, query_string)
    end

    def match(records, query_string)
      return records if query_string.blank?

      records.select do |record|
        record.values.any? { |value| value&.match(query_string) }
      end
    end
  end
end
