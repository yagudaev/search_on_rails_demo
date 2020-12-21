class BackendSimpleSearchController < ApplicationController
  def index
    @results = CSV.read('db/netflix_titles.csv', headers: true)

    @query_string = remove_stop_words(params[:q].downcase)
    @results = @results.select do |r|
      match_by_word(r['title'].downcase, @query_string) ||
        match_by_word(r['cast']&.downcase, @query_string)
    end
  end

  private

  def match_by_word(test_string, query_string)
    return true unless query_string
    return false unless test_string

    query_string.split(' ').any? { |word| test_string.include?(word) }
  end

  def remove_stop_words(str)
    str.gsub(/\bthe|a|an|of\b/, '')
  end
end
