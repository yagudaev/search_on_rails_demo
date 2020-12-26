class Title
  @records = []

  def self.import
    @records = CSV.read('db/netflix_titles.csv', headers: true)
  end

  def self.search(query)
    Search::InMemory.search(@records, query)
  end
end
