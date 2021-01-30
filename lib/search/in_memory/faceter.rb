module Search
  class InMemory
    module Faceter
      def facets(collection, fields = [])
        fields.map do |field|
          {
            field: field.to_s,
            label: field.to_s.titleize,
            items: items(collection, field)
          }
        end
      end

      private

      def items(collection, field)
        collection.group_by { |record| record[field] }.map do |key, values|
          { label: key.to_s, value: key.to_s, count: values.count }
        end
      end
    end
  end
end
