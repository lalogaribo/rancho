class UserMailer < ApplicationMailer
  def registration_confirmation(user)
    @user = user
    mail(to: "#{user.name} <#{user.email}>", subject: 'Confirmacion de Registro')
  end

  def password_reset(user)
    @user = user
    mail(to: "#{user.name} <#{user.email}>", subject: 'Cambio de Contraseña')
  end

  def send_signup_email(user)
    @user = user
    mail(to: @user.email, subject: 'Thanks for signing up for our amazing app')
  end
end
