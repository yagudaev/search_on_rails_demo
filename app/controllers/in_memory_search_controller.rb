class InMemorySearchController < ApplicationController
  def index
    @results = Title.import
    @results = Title.search(params[:q]) if params[:q]
  end
end
