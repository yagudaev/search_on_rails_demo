module PgSimple
  class SearchController < ApplicationController
    ALLOWED_FILTERS = %w[type rating year duration country].freeze

    class TitleSearch < FortyFacets::FacetSearch
      # facet :type
      model 'Title'

      # facet [:participant, :full_name], name: 'Actor'
      facet :year, order: :year
      facet :color
      facet :score
      facet :rating
    end

    def index
      @collection = Title.all

      @filters = filter_params[:filters]&.to_h

      query = params[:q] || ''
      search_options = {
        # sort: params[:sort],
        # filters: @filters,
        # weights: [:title, :director, :cast],
        # with_score: true,
        # facets: ALLOWED_FILTERS,
        # highlight: true
      }
      @results = Title.search(query, search_options)

      # forty facets
      search_params = { "search" => @filters }
      @search = TitleSearch.new(search_params)
      @search.change_root(@results)
      @results = @search.result

      filter = @search.filter(:year)
      @facets = [{
        label: filter.name.titleize,
        field: filter.name,
        items: filter.facet.map do |facet_value|
          {
            label: facet_value.entity,
            count: facet_value.count,
            value: facet_value.entity
          }
        end
      }]
      @sort_by = sort_by
      @sort_options = [['Relevance', '_score_desc'], ['Title A-Z', 'title_asc'], ['Title Z-A', 'title_desc'], ['Other', 'other']]

      @filters = OpenStruct.new @filters

      track_search

      @pagy, @results_page = pagy(@results, items: 30)
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
  end
end
