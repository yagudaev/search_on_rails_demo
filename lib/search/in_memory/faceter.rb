module Search
  class InMemory
    module Faceter
      def facets(initial_collection, query, options = {})
        fields = options[:facets]
        fields.map do |field|
          {
            field: field.to_s,
            label: field.to_s.titleize,
            items: items(search(initial_collection, query, without(options, filter: field)), field)
          }
        end
      end

      private

      def items(collection, field)
        collection.group_by { |record| record[field] }.map do |key, values|
          { label: key.to_s, value: key.to_s, count: values.count }
        end
      end

      def without(options, filter:)
        { **options, filters: options[:filters]&.except(filter), highlight: false }
      end
    end
  end
end
