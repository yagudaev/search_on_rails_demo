class BackendSimpleSearchController < ApplicationController
  def index
    @results = CSV.read('db/netflix_titles.csv', headers: true)

    @query_string = remove_stop_words(params[:q].downcase)
    @results = @results.select do |r|
      match_by_word(r['title'].downcase, @query_string) ||
        match_by_word(r['cast']&.downcase, @query_string)
    end

    @results = @results.select do |r|
      match_by_word(r['title'].downcase, @query_string) ||
        match_by_word(r['cast']&.downcase, @query_string)
    end

    @results = add_highlights(@results)
    @results = add_score(@results)
  end

  private

  def match_by_word(test_string, query_string)
    return true unless query_string.present?
    return false unless test_string.present?

    query_string.split(' ').any? { |word| test_string.include?(word) }
  end

  def remove_stop_words(str)
    str.gsub(/\b(the|a|an|of|to)\b/, '')
  end

  def add_highlights(results)
    results.each do |result|
      result['title'] = add_highlight(result['title'].downcase)
      result['cast'] = add_highlight(result['cast'].downcase) if result['cast']
    end
  end

  def add_highlight(str)
    words = @query_string.split(' ')

    words.reduce(str) do |accumulator, word|
      start_pos = accumulator.index(word)

      next str unless start_pos

      end_pos = start_pos + word.length

      opening_tag = '<b>'
      closing_tag = '</b>'
      new_str = accumulator.insert(start_pos, opening_tag)
      new_str = new_str.insert(end_pos + opening_tag.length, closing_tag)

      new_str
    end
  end

  def add_score(results)
    # highest if found in title > cast | 10^2 (100), 10^1 (10)
    # full word > partial word  | 5 & 2
    # start of text > middle of text > end of text | 3, 2, 1
    results.each do |result|
      result['_score'] = 10**2
    end
  end
end
