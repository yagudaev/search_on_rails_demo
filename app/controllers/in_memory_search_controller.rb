class InMemorySearchController < ApplicationController
  ALLOWED_FILTERS = %w[type rating release_year duration country].freeze

  def index
    @results = Title.import

    @filters = OpenStruct.new filter_params.dig(:filters)&.to_h
    @results = Title.search(params[:q] || '', sort: params[:sort], weights: [:title, :director, :cast], with_score: true)
    @facets = Title.facets(@results, ALLOWED_FILTERS)
    @sort_by = sort_by
    @sort_options = [['Relevance', '_score_desc'], ['Title A-Z', 'title_asc'], ['Title Z-A', 'title_desc'], ['Other', 'other']]

    @pagy, @results_page = pagy_array(@results, items: 30)
  end

  private

  def permitted_params
    params.permit(:q, sort: [:field, :direction]).merge(filter_params)
  end
  helper_method :permitted_params

  def filter_params
    params.permit(filters: allowed_filters_params)
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
