module Search
  class InMemory
    module Filter
      def filter(collection, filters)
        collection.select do |record|
          filters.all? do |filter|
            field = filter[:field]&.to_sym
            values = filter[:values]

            values&.is_a?(Array) ?
              values&.include?(record[field]) :
              values == record[field]
          end
        end
      end
    end
  end
end
