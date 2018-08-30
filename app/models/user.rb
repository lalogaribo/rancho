class User < ApplicationRecord
  before_save :downcase_email
  before_create :set_confirmation_token
  validates :name, presence: { message: 'Nombre es requerido' },
                   length: { maximum: 250 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: { message: 'Email es requerido' },
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_many :predios, dependent: :destroy
  has_secure_password
  validates :password, presence: { message: 'Contraseña es requerdo' },
                       length: { minimum: 5, maximum: 255 },
                       allow_nil: true
  has_many :materials, dependent: :destroy
  has_many :info_predio, dependent: :destroy
  has_many :vuelos, dependent:  :destroy
  has_many :requests, dependent: :destroy
  has_many :workers, dependent: :destroy

  # Activate user
  def validate_email
    self.email_confirmed = true
    self.confirm_token = nil
  end

  # Reset Token
  def authenticated_reset_token?(token)
    (reset_token).eql?(token)
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Sets the password reset attributes.
  def create_reset_token
    reset_digest = User.new_token
    update_attribute(:reset_token, reset_digest)
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def clean_reset_token
    self.reset_token = nil
    self.reset_sent_at = nil
  end

  private

  # Converts email to all lower-case.
  def downcase_email
    self.email = email.downcase
  end

  def set_confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = User.new_token
    end
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end
end
