module InMemory
  class Title
    @records = []

    def self.import
      @records = CSV.read('db/netflix_titles.csv', headers: true).map { |r| r.to_h.with_indifferent_access }
    end

    def self.find(id)
      import

      record = @records.find { |f| f[:show_id] == id }
      raise 'not found' unless record
      record
    end

    def self.search(query, options = {})
      Search::InMemory.new.search(@records, query, options)
    end

    def self.facets(collection, query, search_options)
      Search::InMemory.new.facets(collection, query, search_options)
    end
  end
end
