module Search
  class InMemory
    module Matcher
      def match(records, query_string)
        return records if query_string.blank?

        records.select do |record|
          record.values.any? { |value| value&.match(query_string) }
        end
      end
    end
  end
end
