# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Devise2App::Application.initialize!
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings =
{
:address => "smtp.gmail.com",
:port => 587,
:domain => "gmail.com",
:user_name => "sachinidify@gmail.com" ,
:password => "12345qwert@",
:authentication => "plain",
:enable_starttls_auto => true
}
