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
        return text if text.blank?

        start_pos = text.index(query_string)

        return text if query_string.blank?
        return text unless start_pos

        add_markup(text: text, start_pos: start_pos, length: query_string.length)
      end

      def add_markup(text:, start_pos:, length:)
        opening_tag = '<b>'
        closing_tag = '</b>'

        highligthed = text.insert(start_pos, opening_tag)
        end_pos = start_pos + opening_tag.length + length

        highligthed.insert(end_pos, closing_tag)
      end
    end
  end
end
