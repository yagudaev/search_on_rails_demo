module Search
  class InMemory
    module Highlighter
      def highlight(records, query_string, searchable_fields = nil)
        records.each do |record|
          keys = searchable_fields || record.keys
          keys.each do |key|
          end

        #   result['title'] = add_highlight(result['title'].downcase, result, weight: 2)
        #   result['cast'] = add_highlight(result['cast'].downcase, result, weight: 1) if result['cast']
        end
      end

      private

      def add_highlight(str, result, weight:)
        words = @query_string.split

        score = 10**weight

        # matches
        highligthed_str = words.reduce(str) do |accumulator, word|
          start_pos = accumulator.index(word)

          next str unless start_pos

          opening_tag = '<b>'
          closing_tag = '</b>'
          new_str = accumulator.insert(start_pos, opening_tag)

          end_pos = start_pos + opening_tag.length + word.length
          new_str = new_str.insert(end_pos , closing_tag)

          # scoring
          if (end_pos + closing_tag.length > new_str.length || new_str[[end_pos + closing_tag.length, new_str.length - 1].min].match(/[\s|:]/)) && new_str[start_pos - 1].match(/[\s|:]/) # full word
            score += 5
          else # partial word
            score += 2
          end

          score += 3 if start_pos == 0
          score += 2 if start_pos > 0 && end_pos + word.length < str.length
          score += 1 if end_pos + word.length == str.length

          new_str
        end

        result['_score'] = score
        highligthed_str
      end
    end
  end
end
