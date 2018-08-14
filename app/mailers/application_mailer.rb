class ApplicationMailer < ActionMailer::Base
  default from: 'welcome@asosiacionplatanera.com'
  layout 'mailer'

  def registration_confirmation(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}", :subject => 'Confirmacion de Registro')
  end
end
