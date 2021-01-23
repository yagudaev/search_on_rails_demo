module Search
  class InMemory
    module Sorter
      def sort(collection, _query, _sort_options = {})
        collection
      end
    end
  end
end
