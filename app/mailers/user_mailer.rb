class UserMailer < ApplicationMailer
  def registration_confirmation(user)
    @user = user
    mail(to: "#{user.name} <#{user.email}>", subject: 'Confirmacion de Registro')
  end

  def password_reset(user)
    @user = user
    mail(to: "#{user.name} <#{user.email}>", subject: 'Cambio de Contraseña')
  end

  def reset_chart_token(user)
    @user = user
    mail to: "#{user.name} <#{user.email}>", subject: 'Nuevo token para generacion de graficas'
  end

  def send_signup_email(user)
    @user = user
    mail(to: @user.email, subject: 'Thanks for signing up for our amazing app')
  end
end
