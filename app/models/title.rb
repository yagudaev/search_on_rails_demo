class Title < ApplicationRecord
  has_many :appearances
  has_many :actor_appearances, -> { acting }, class_name: 'Appearance'
  has_many :participants, through: :appearances
  has_many :actors, through: :actor_appearances, class_name: 'Participant', source: :participant

  # TODO: extract all search stuff into a concern
  scope :search, ->(query) do
    return self if query.blank?

    scope = where("title iLIKE ?", "%#{query}%")

    scope
  end

  scope :sort_by_param, ->(param) do
    param = param.with_indifferent_access
    field = param[:field]
    direction = param[:direction]

    return self if !field || !direction

    order(field => direction)
  end

  class Faceter < FortyFacets::FacetSearch
    model 'Title'

    facet [:actors, :full_name], name: "actors-full_name"
    facet :type
    facet :year
    facet :color
    facet :score
    facet :rating, order: ->(label) { -label }
  end

  class << self
    def facets(filters)
      results = self

      search_params = { search: filters }.with_indifferent_access
      search = Faceter.new(search_params)
      search.change_root(results)
      results = search.result(skip_ordering: true)
      # results = @results.order(sort_by_ar) if sort_by_ar

      facets = map_facets(search, [[:actors, :full_name], :type, :rating, :year, :color])

      [results, facets]
    end

    private

    def map_facets(search, fields)
      fields.map do |field|
        filter = search.filter(field)

        serialize_facet(filter)
      end
    end

    def serialize_facet(filter)
      {
        label: filter.name.titleize,
        field: filter.name,
        items: serialize_facet_items(filter)
      }
    end

    def serialize_facet_items(filter)
      filter.facet.first(10).map do |facet_value|
        {
          label: facet_value.entity,
          count: facet_value.count,
          value: facet_value.entity
        }
      end
    end
  end
end
