class Worker < ApplicationRecord
  validates :name, presence: {message: "Nombre es requerido"}
  validates :last_name, presence: {message: "Apellido es requerido"}
  validates :phone_number, presence: {message: "Telefono es requerido"},
            length: {maximum: 10, message: 'Ingresar un numero valido'},
            numericality: {message: 'Ingresar numero valido'},
            format: {with: /\A\d+(?:\.\d{0,2})?\z/, message: 'Ingresar numero valido'}
  belongs_to :user
  belongs_to :worker_type
  has_many :info_predio_worker
  has_many :info_predio, through: :info_predio_worker

  def fullname
    "#{name} #{last_name}"
  end
end
