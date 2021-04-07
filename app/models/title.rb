class Title < ApplicationRecord
  scope :search, ->(query, search_options) do
    return self if query.blank?

    scope = where("title iLIKE ?", "%#{query}%")
    if search_options[:sort]
      scope = scope.order(search_options.dig(:sort, "field") => search_options.dig(:sort, "direction"))
    end

    scope
  end
end
