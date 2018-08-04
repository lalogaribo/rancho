class Worker < ApplicationRecord
  validates :name, presence: { message: "Nombre es requerido" }
  validates :last_name, presence: { message: "Apellido es requerido" }
  validates :phone_number, presence: { message: "Telefono es requerido" },
            length: { maximum: 10 },
            numericality: { only_integer: true}
  belongs_to :user
end
