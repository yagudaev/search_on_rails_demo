class Appearance < ApplicationRecord
  belongs_to :title
  belongs_to :participant

  enum role: { actor: 0, director: 1 }
end
