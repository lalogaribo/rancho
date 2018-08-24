class Worker < ApplicationRecord
  validates :name, presence: {message: "Nombre es requerido"}
  validates :last_name, presence: {message: "Apellido es requerido"}
  validates :phone_number, presence: {message: "Telefono es requerido"},
            length: {maximum: 10},
            numericality: {message: 'Ingresar numero valido'},
            format: {with: /\A\d+(?:\.\d{0,2})?\z/, message: 'Ingresar numero valido'}
  belongs_to :user
  has_one :worker_type
end
