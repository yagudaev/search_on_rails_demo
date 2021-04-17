module PgSimple
  class SearchController < ApplicationController
    ALLOWED_FILTERS = %w[type rating year color actors-full_name].freeze

    def index
      @filters = filter_params[:filters]&.to_h

      query = params[:q] || ''
      @results = Title.search(query)
      @results, @facets = @results.facets(@filters)
      @results = @results.sort_by_param(permitted_params[:sort].to_h)

      @sort_by = sort_by
      @sort_options = [['Relevance', '_score_desc'], ['Title A-Z', 'title_asc'], ['Title Z-A', 'title_desc'], ['Other', 'other']]

      @filters = OpenStruct.new @filters

      track_search

      @pagy, @results_page = pagy(@results, items: 30)
    end

    def filter
      result = Title.ransack("#{params[:field].downcase}_start" => params[:query]&.downcase).result.limit(10)
      render json: serialize_titles(result, params[:field])
    end

    private

    def permitted_params
      params.permit(:q, sort: [:field, :direction]).merge(filter_params)
    end
    helper_method :permitted_params

    def serialize_titles(titles, field)
      # TODO: fix me so it doesn't say unkown, assocication + ransack
      titles.map do |title|
        { label: title[field] || 'Unknown', value: title[field] || 'Unknown', count: 0 }
      end
    end

    def filter_params
      params.permit(filters: allowed_filters_params)
    end

    def track_search
      filters = ""
      filters = "_filters_:#{@filters.to_json}" if @filters&.present?
      Searchjoy::Search.create(
        search_type: "Title",
        query: "#{params[:q]}#{filters}",
        results_count: @results.dup.reselect("titles.*").count,
        user_id: nil
      )
    end

    def allowed_filters_params
      ALLOWED_FILTERS.map do |f|
        { f.to_s.to_sym => [] }
      end.reduce({}, :merge)
    end

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
end
