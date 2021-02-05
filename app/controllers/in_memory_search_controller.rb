class InMemorySearchController < ApplicationController
  ALLOWED_FILTERS = %w[type rating release_year duration country].freeze

  def index
    @collection = Title.import

    @filters = filter_params.dig(:filters)&.to_h

    query = params[:q] || ''
    search_options = {
      sort: params[:sort],
      filters: @filters,
      weights: [:title, :director, :cast],
      with_score: true,
      facets: ALLOWED_FILTERS,
      highlight: true
    }

    # TODO: consider changing the object
    @results = Title.search(query, search_options)
    @facets = Title.facets(@collection, query, search_options)
    @sort_by = sort_by
    @sort_options = [['Relevance', '_score_desc'], ['Title A-Z', 'title_asc'], ['Title Z-A', 'title_desc'], ['Other', 'other']]

    @filters = OpenStruct.new @filters

    track_search

    @pagy, @results_page = pagy_array(@results, items: 30)
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
