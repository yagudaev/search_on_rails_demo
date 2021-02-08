module Search
  class InMemory
    module Highlighter
      def highlight(records, query_string)
        records.each do |record|
          record.each_key do |key|
            record[key] = with_highlights(text: record[key], query_string: query_string)
          end
        end
      end

      private

      def with_highlights(text:, query_string:)
        return text if query_string.empty?

        text.gsub(query_string, "<b>#{query_string}</b>")
      end
    end
  end
end
