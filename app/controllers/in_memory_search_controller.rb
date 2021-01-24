class InMemorySearchController < ApplicationController
  def index
    @results = Title.import

    @results = Title.search(params[:q] || '', sort: params[:sort])
    @sort_by = params.dig(:sort, :field) == 'title' ? "title_#{params.dig(:sort, :direction)}" : 'other'

    @pagy, @results_page = pagy_array(@results)
  end
end
