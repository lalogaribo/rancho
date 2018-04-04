class InfoPredio < ApplicationRecord
  has_one :predio
  has_many :material, through: :info_predio_detalle
  has_many :otros_gasto
  has_one :nutriente, through: :info_predio_nutriente
  belongs_to :user
end
