module Search
  class InMemory
    module Sorter
      def sort(collection, _query, sort_options = nil)
        return collection if collection.length <= 1
        return collection unless sort_options

        collection.sort_by { |record| record[sort_options[:field]&.to_sym] }
      end
    end
  end
end
