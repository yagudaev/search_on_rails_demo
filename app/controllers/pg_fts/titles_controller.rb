module PgFts
  class TitlesController < ApplicationController
    def show
      @title = Title.find(params[:id])
      track_conversion
    end

    private

    def track_conversion
      search = Searchjoy::Search.find_by(query: params[:q])
      search.convert
    end
  end
end
