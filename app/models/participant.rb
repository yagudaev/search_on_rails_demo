class Participant < ApplicationRecord
  has_many :appearances, dependent: :destroy
  has_many :acting_appearances, -> { acting }, class_name: 'Appearance', dependent: :destroy, inverse_of: :participant
  has_many :titles, through: :appearances
  has_many :acted_in_titles, through: :acting_appearances, source: :title

  scope :actors, -> { joins(:appearances).where(appearances: { role: :actor }) }
end
