# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

Rails.application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  config.action_mailer.smtp_settings = {
    address:              'smtp.i.ua',
    port:                 587,
    domain:                'i.ua',
    user_name:            ENV['MAIL_ADDRESS'],
    password:             ENV['MAIL_PASSWORD'],
    authentication:       'plain',
    enable_starttls_auto: true
  }

end