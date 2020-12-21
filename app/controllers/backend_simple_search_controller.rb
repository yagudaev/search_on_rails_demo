class BackendSimpleSearchController < ApplicationController
  def index
    @results = CSV.read('db/netflix_titles.csv')
  end
end
