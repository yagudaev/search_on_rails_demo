class InMemorySearchController < ApplicationController
  def index
    @results = Title.import

    @results = Title.search(params[:q] || '', sort: params[:sort], weights: [:title, :director, :cast], with_score: true)
    @facets = Title.facets(@results, ['type', 'rating', 'release_year', 'duration'])
    @sort_by = sort_by
    @sort_options = [['Relevance', '_score_desc'], ['Title A-Z', 'title_asc'], ['Title Z-A', 'title_desc'], ['Other', 'other']]

    @pagy, @results_page = pagy_array(@results)
  end

  private

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
