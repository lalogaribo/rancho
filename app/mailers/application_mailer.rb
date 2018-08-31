class ApplicationMailer < ActionMailer::Base
  default from: 'welcome@asosiacionplatanera.com'
  layout 'mailer'

  def registration_confirmation(user)
    @user = user
    mail :to => "#{user.name} <#{user.email}", :subject => 'Confirmacion de Registro'
  end

  def password_reset(user)
    @user = user
    mail to: "#{user.name} <#{user.email}", subject: 'Cambio de Contraseña'
  end

  def reset_chart_token(user)
    @user = user
    mail to: "#{user.name} <#{user.email}", subject: 'Nuevo token para generacion de graficas'
  end
end
