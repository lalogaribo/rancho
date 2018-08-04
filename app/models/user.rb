class User < ApplicationRecord
  before_save {self.email = email.downcase}
  validates :name, presence: {message: 'Nombre es requerido'},
            length: {maximum: 30}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: { message: 'Email es requerido'},
            length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  has_many :predios
  has_secure_password
  validates :password, presence: { message: 'Contraseñaes requerdo'},
            length: {minimum: 5},
            allow_nil: true
  has_many :materials
  has_many :info_predio
  has_many :vuelos
  has_many :requests
  has_many :workers
end