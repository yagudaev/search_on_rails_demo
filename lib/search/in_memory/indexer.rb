module Search
  class InMemory
    module Indexer
      def index(collection, fields)
        inverted_index = {}

        collection.each do |record|
          field = fields.first
          words = record[field]&.split(' ') || []
          words.each do |word|
            word = word.downcase
            inverted_index[word] ||= []
            inverted_index[word].push(record[:id])
          end
        end

        inverted_index
      end
    end
  end
end
