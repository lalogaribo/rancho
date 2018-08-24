class User < ApplicationRecord
  before_save {self.email = email.downcase}
  validates :name, presence: {message: 'Nombre es requerido'},
            length: {maximum: 250}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: {message: 'Email es requerido'},
            length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false, message: 'Este correo esta siendo usado por otro usuario'}
  has_secure_password
  validates :password, presence: {message: 'Contraseña es requerdo'},
            length: {minimum: 5, maximum: 255, message: 'La contraseña tiene que tener 5 caractereres como minimo'},
            allow_nil: true
  has_many :predios
  has_many :materials
  has_many :info_predio
  has_many :vuelos
  has_many :requests
  has_many :workers
end