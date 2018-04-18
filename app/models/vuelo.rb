class Vuelo < ApplicationRecord
  belongs_to :user
  validates :predio, presence: true
  validates :precio_vuelo, presence: true
end
