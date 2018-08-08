class Predio < ApplicationRecord
  validates :name, presence: {message: 'Nombre es un campo requerido'}
  validates :no_hectareas, presence: {message: 'Numero de hectareas es requerido'},
            numericality: {only_integer: true},
            length: {maximum: 30000}
  belongs_to :user
  has_many :info_predio
  validates :user_id, presence: true
  default_scope -> {order(updated_at: :DESC)}
end