ActionMailer::Base.smtp_settings = {
    :user_name => 'apikey',
    :password => Rails.application.secrets.SENDGRID_API_KEY,
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
}
