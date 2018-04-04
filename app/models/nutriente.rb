class Nutriente < ApplicationRecord
  validates :nombre, presence: true
  validates :precio, presence: true
  has_many :info_predio, through: :info_predio_nutriente
end
