class Title < ApplicationRecord
  has_many :appearances
  has_many :actor_appearances, -> { acting }, class_name: 'Appearance'
  has_many :participants, through: :appearances
  has_many :actors, through: :actor_appearances, class_name: 'Participant', source: :participant

  scope :search, ->(query, search_options) do
    return self if query.blank?

    scope = where("title iLIKE ?", "%#{query}%")
    if search_options[:sort]
      scope = scope.order(search_options.dig(:sort, "field") => search_options.dig(:sort, "direction"))
    end

    scope
  end
end
