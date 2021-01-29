class Title
  @records = []

  def self.import
    @records = CSV.read('db/netflix_titles.csv', headers: true).map(&:to_h)
  end

  def self.search(query, options = {})
    Search::InMemory.new.search(@records, query, options)
  end

  def self.facets(results, fields)
    Search::InMemory.new.facets(results, fields)
  end
end
