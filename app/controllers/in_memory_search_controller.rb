class InMemorySearchController < ApplicationController
  def index
    @results = Title.import

    @results = Title.search(params[:q] || '', sort: params[:sort])
    @sort_by = params.dig(:sort, :field) == 'title' ? "title_#{params.dig(:sort, :direction)}" : 'other'
    @sort_options = [['Relevance', '_score_desc'], ['Title A-Z', 'title_asc'], ['Title Z-A', 'title_desc'], ['Other', 'other']]

    @pagy, @results_page = pagy_array(@results)
  end
end
