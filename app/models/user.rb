class User < ApplicationRecord
  ############################################################################################
  ## PeterGate Roles                                                                        ##
  ## The :user role is added by default and shouldn't be included in this list.             ##
  ## The :root_admin can access any page regardless of access settings. Use with caution!   ##
  ## The multiple option can be set to true if you need users to have multiple roles.       ##
  petergate(roles: [:site_admin, :producer, :owner], multiple: false) ##
  ############################################################################################ 
 

  before_save {self.email = email.downcase}
  validates :name, presence: {message: 'Nombre es requerido'},
            length: {maximum: 250}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: {message: 'Email es requerido'},
            length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  has_many :predios
  has_secure_password
  validates :password, presence: {message: 'Contraseña es requerdo'},
            length: {minimum: 5, maximum: 255},
            allow_nil: true
  has_many :materials
  has_many :info_predio
  has_many :vuelos
  has_many :requests
  has_many :workers
end