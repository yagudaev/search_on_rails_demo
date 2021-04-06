class Title < ApplicationRecord
  scope :search, ->(query, _search_options) do
    return self if query.blank?

    where("title iLIKE ?", "%#{query}%")
  end
end
