module Search
  class InMemory
    module Filter
      def filter(collection, filters)
        collection.select do |record|
          filters.all? do |field, values|
            values&.is_a?(Array) ?
              values&.include?(record[field]) :
              values == record[field]
          end
        end
      end
    end
  end
end
