class User < ApplicationRecord
  before_save { self.email = email.downcase }
  before_create :set_confirmation_token
  validates :name, presence: { message: 'Nombre es requerido' },
                   length: { maximum: 250 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: { message: 'Email es requerido' },
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_many :predios
  has_secure_password
  validates :password, presence: { message: 'Contraseña es requerdo' },
                       length: { minimum: 5, maximum: 255 },
                       allow_nil: true
  has_many :materials
  has_many :info_predio
  has_many :vuelos
  has_many :requests
  has_many :workers

  def validate_email
    self.email_confirmed = true
    self.confirm_token = nil
  end

  private

  def set_confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end
end
