class BackendSimpleSearchController < ApplicationController
  def index
    @results = CSV.read('db/netflix_titles.csv', headers: true)

    # TODO: extract into search with rspec tests
    return unless params[:q]

    @query_string = remove_stop_words(params[:q]&.downcase)
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
      result['title'] = add_highlight(result['title'].downcase, result, weight: 2)
      result['cast'] = add_highlight(result['cast'].downcase, result, weight: 1) if result['cast']
    end
  end

  def add_highlight(str, result, weight:)
    words = @query_string.split(' ')

    score = 10**weight

    # matches
    highligthed_str = words.reduce(str) do |accumulator, word|
      start_pos = accumulator.index(word)

      next str unless start_pos

      opening_tag = '<b>'
      closing_tag = '</b>'
      new_str = accumulator.insert(start_pos, opening_tag)

      end_pos = start_pos + opening_tag.length + word.length
      new_str = new_str.insert(end_pos , closing_tag)

      # scoring
      if (end_pos + closing_tag.length > new_str.length || new_str[end_pos + closing_tag.length].match(/[\s|:]/)) && new_str[start_pos - 1].match(/[\s|:]/) # full word
        score += 5
      else # partial word
        score += 2
      end

      score += 3 if start_pos == 0
      score += 2 if start_pos > 0 && end_pos + word.length < str.length
      score += 1 if end_pos + word.length == str.length

      new_str
    end

    result['_score'] = score
    highligthed_str
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
