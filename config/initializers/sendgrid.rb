
ActionMailer::Base.smtp_settings = {
    :user_name => 'apikey',
    :password => Rails.application.secrets.sendgrid_api_key,
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
}

