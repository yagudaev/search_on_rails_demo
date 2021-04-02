class Title < ApplicationRecord
  def self.search(query, _search_options)
    return self if query.blank?

    where("title iLIKE ?", "%#{query}%")
  end
end
