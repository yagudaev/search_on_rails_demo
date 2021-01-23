module Search
  class InMemory
    module Sorter
      def sort(collection, _query, sort_options = nil)
        return collection if collection.length <= 1
        return collection unless sort_options

        collection.sort do |record_a, record_b|
          a = record_a[sort_options[:field]&.to_sym]
          b = record_b[sort_options[:field]&.to_sym]

          sort_options[:direction] == 'ascending' ? a <=> b : b <=> a
        end
      end
    end
  end
end
