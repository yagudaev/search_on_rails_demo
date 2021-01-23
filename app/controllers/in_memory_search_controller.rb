class InMemorySearchController < ApplicationController
  def index
    @results = Title.import

    @results = Title.search(params[:q] || '', sort: params[:sort])

    @pagy, @results_page = pagy_array(@results)
  end
end
