module PgSimple
  class SearchController < ApplicationController
    ALLOWED_FILTERS = %w[type rating year color actor].freeze
    SORTABLE = Title.column_names

    class TitleSearch < FortyFacets::FacetSearch
      # facet :type
      model 'Title'

      facet [:actors, :full_name], name: "actor"
      facet :type
      facet :year
      facet :color
      facet :score, order: ->(label) { nil }
      facet :rating, order: ->(label) { -label }
    end

    def index
      @collection = Title.all

      @filters = filter_params[:filters]&.to_h

      query = params[:q] || ''
      search_options = {
        sort: params[:sort],
        # filters: @filters,
        # weights: [:title, :director, :cast],
        # with_score: true,
        # facets: ALLOWED_FILTERS,
        # highlight: true
      }
      @results = Title.search(query, search_options).limit(10)

      # forty facets
      search_params = { search: @filters }.with_indifferent_access
      @search = TitleSearch.new(search_params)
      @search.change_root(@results)
      @results = @search.result(skip_ordering: true)
      @results = @results.order(sort_by_ar) if sort_by_ar

      # @facets = map_facets([:type, :rating, :year, :color, :score])
      @facets = map_facets([[:actors, :full_name], :type, :rating, :year, :color])
      @sort_by = sort_by
      @sort_options = [['Relevance', '_score_desc'], ['Title A-Z', 'title_asc'], ['Title Z-A', 'title_desc'], ['Other', 'other']]

      @filters = OpenStruct.new @filters
      @results = @results.limit(nil)

      track_search

      @pagy, @results_page = pagy(@results, items: 30)
    end

    private

    def map_facets(fields)
      fields.map do |field|
        filter = @search.filter(field)

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

    def permitted_params
      params.permit(:q, sort: [:field, :direction]).merge(filter_params)
    end
    helper_method :permitted_params

    def filter_params
      params.permit(filters: allowed_filters_params)
    end

    def track_search
      Searchjoy::Search.create(
        search_type: "Title",
        query: params[:q],
        results_count: @results.count,
        user_id: 1
      )
    end

    def allowed_filters_params
      ALLOWED_FILTERS.map do |f|
        { f.to_s.to_sym => [] }
      end.reduce({}, :merge)
    end

    def sort_by
      case params.dig(:sort, :field)
      when 'title'
        "title_#{params.dig(:sort, :direction)}"
      when '_score'
        '_score_desc'
      else
        'other'
      end
    end

    def sort_by_ar
      field = params.dig(:sort, :field)
      direction = params.dig(:sort, :direction)

      return nil if !field || !direction

      { field => direction }
    end

    def sort_by_forty
      field = params.dig(:sort, :field)
      case field
      when *SORTABLE
        "#{field}_#{params.dig(:sort, :direction)}"
      when '_score'
        '_score_desc'
      else
        'other'
      end
    end
  end
end
