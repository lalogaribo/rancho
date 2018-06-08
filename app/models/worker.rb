class Worker < ApplicationRecord
  validates :name, presence: { message: "Nombre es requerido" }
  validates :last_name, presence: { message: "Apellido es requerido" }
  validates :phone_number, presence: { message: "Telefono es requerido" }
  belongs_to :user
end
