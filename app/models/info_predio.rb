class InfoPredio < ApplicationRecord
  belongs_to :predio
  belongs_to :user
  has_many :info_predio_detalle
  has_many :material, through: :info_predio_detalle
  has_many :otros_gasto
  validates :fumigada, presence: { message: 'es un campo requerido' }
  validates :pago_trabaja, presence: { message: 'es un campo requerido' }
  validates :conteo_racimos, presence: { message: 'es un campo requerido' }
  validates :color_cinta, presence: { message: 'es un campo requerido' }
  validates :semana, presence: { message: 'es un campo requerido' }
  validates :fecha_embarque, presence: { message: 'es un campo requerido' }
  validates :precio, presence: { message: 'es un campo requerido' }
  validates :venta, presence: { message: 'es un campo requerido' }
  validates :nutriente, presence: { message: 'es un campo requerido' }
end
