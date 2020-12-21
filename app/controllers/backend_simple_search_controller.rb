class BackendSimpleSearchController < ApplicationController
  def index
    @results = CSV.read('db/netflix_titles.csv', headers: true)

    @query_string = params[:q]
    @results = @results.select { |r| r['title'].include?(@query_string) }
  end
end
