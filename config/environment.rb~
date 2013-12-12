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
ENV['TWITTER_KEY'] = 'OZOCbpP8qJqr4tufH88pSg'
ENV['TWITTER_SECRET'] = 'NU4S1DsmTcNbBJggdHwtu86J0rio536tzrcwgOz4lM'
