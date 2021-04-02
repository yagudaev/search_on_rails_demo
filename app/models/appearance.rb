class Appearance < ApplicationRecord
  belongs_to :title
  belongs_to :participant

  scope :acting, -> { where(role: :actor) }

  enum role: { actor: 0, director: 1 }
end
