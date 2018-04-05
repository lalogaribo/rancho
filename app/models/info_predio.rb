class InfoPredio < ApplicationRecord
  belongs_to :predio
  has_many :material, through: :info_predio_detalle
  has_many :otros_gasto
  has_one :nutriente, through: :info_predio_nutriente
  validates :fumigada, presence: { message: 'es un campo requerido' }
  validates :pago_trabaja, presence: { message: 'es un campo requerido' }
  validates :conteo_racimos, presence: { message: 'es un campo requerido' }
  validates :color_cinta, presence: { message: 'es un campo requerido' }
  validates :semana, presence: { message: 'es un campo requerido' }

end
