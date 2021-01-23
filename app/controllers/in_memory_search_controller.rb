class InMemorySearchController < ApplicationController
  def index
    @results = Title.import
    @results = Title.search(params[:q]) if params[:q]

    @pagy, @results_page = pagy_array(@results)
  end
end
