module Search
  class InMemory
    module Indexer
      def index(collection, fields)
        inverted_index = {}

        collection.each do |record|
          fields.each do |field|
            index_field(field, record, inverted_index)
          end
        end

        inverted_index
      end

      private

      def index_field(field, record, inverted_index)
        words = record[field]&.split(' ') || [] # tokenization
        words.each do |word|
          word = word.downcase # normalization
          inverted_index[field] ||= {}
          inverted_index[field][word] ||= []
          inverted_index[field][word].push(record[:id])
        end
      end
    end
  end
end
