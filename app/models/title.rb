class Title
  @records = []

  def self.import
    @records = CSV.read('db/netflix_titles.csv', headers: true).map(&:to_h)
  end

  def self.search(query, options = {})
    Search::InMemory.new.search(@records, query, options)
  end

  def self.facets(results)
    @facets = [
      {
        label: 'Type',
        field: 'type',
        items: [
          {
            label: 'Movie',
            value: 'movie',
            count: 6
          },
          {
            label: 'TV Show',
            value: 'tv_show',
            count: 2
          }
        ]
      }
    ]
    # Search::InMemory.new.facets(results)
  end
end
