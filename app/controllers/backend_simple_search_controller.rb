class BackendSimpleSearchController < ApplicationController
  def index
    @results = CSV.read('db/netflix_titles.csv', headers: true)

    @query_string = params[:q].downcase
    @results = @results.select do |r|
      r['title'].downcase.include?(@query_string) ||
        r['cast']&.downcase&.include?(@query_string)
    end
  end
end
