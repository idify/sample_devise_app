sample_devise_app

 To add devise gem in project

1) add devise gem in gem file
then bundle install

2)Then execute command
rails generate devise:install
3) then rake db:create

4) execute this command to save user cradential for log in and authentication and name it as per requirment  
rails generate devise MODEL
5) after signin describe where to redirect in routes file 
for example
root to: "home#index"
6) to install devise view
rails g devise:views
7) add this line line in config/environments/development.rb file
config.action_mailer.default_url_options = { :host => 'localhost:3000' }

8) add these lines in layout/application.html.erb file
for error messages and notice
 <p class="notice"><%= notice %></p>
  <p class="alert"><%= alert %></p>
9) to activate remember me obtion add it in devise in user.rb file
and paste this line in config/initialise/devise.rb file 
Devise::TRUE_VALUES << ["on"]
10) to activate timeoutable function in devise 
add this code in user.rb file
 # to customise timeoutable
  def timeout_in
  60.seconds #time according to requirment
end
11) to activate lockable

in config/initialise/devise add these line to lock reasion and also to give warning
 config.lock_strategy = :failed_attempts
 config.maximum_attempts = 3
 config.last_attempt_warning = true
to unlock two stretrgies are 
to define add these lines
 config.unlock_strategy = :both
after this time account unlock automatically
config.unlock_in = 1.hour
or can unlock through your domain id from which you create account
7) password reset after first log in 
add in config/initialise/devise
config.reset_password_within = 6.hours
8) to reset password length
 config.password_length = 8..128
9) to activate confirmable
add it in devise in user.rb
and create migration to add columns to user model
 add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at,       :datetime
    add_column :users, :confirmation_sent_at , :datetime
    add_column :users, :unconfirmed_email, :string

    add_index  :users, :confirmation_token, :unique => true

and add these code in 
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

 
10)The time the user will be remembered without asking for credentials again.
   config.remember_for = 2.days
11) add omniauth in devise
it is used to authenticate through third party 
like facebook ,twitter and gmail

* for facebook
add omniauthable in devise
and then add these gem in gem file
gem 'omniauth'
gem 'omniauth-facebook'
*Add columns "provider", "uid" and "name" to your User model
rails g migration AddColumnsToUsers provider uid name
*add these in attr_accessible :provider, :uid, :name
*add these lines in config/initializers/devise.rb
require "omniauth-facebook"
config.omniauth :facebook, "561221117304359", "b16a1c14eb52aad5341247ef20bc319a", :strategy_class => OmniAuth::Strategies::Facebook


config.omniauth :facebook, ENV['facebook_code'], ENV['facebook_SECRET'],
      :client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}

* add this in devise :omniauthable, :omniauth_providers => [:facebook]
in array we can pass how much provider we need like facebook,gmail twitter
* genrate omniouth controller and exten it from devise example
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
*add these method in user.rb file
 def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
    end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
  user = User.where(:provider => auth.provider, :uid => auth.uid).first
  unless user
    user = User.create(name:auth.extra.raw_info.name,
                         provider:auth.provider,
                         uid:auth.uid,
                         email:auth.info.email,
                         password:Devise.friendly_token[0,20]
                         )
  end
  user
  end

* add these lines in config/routes.rb file
devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

facebook omniouth ready to work

12) to add omniauth for Gmail 
add gem 'omniauth-google-oauth2'
and then bundle install
*devise :omniauthable, :omniauth_providers => [:google_oauth2]
*add this code in omniouthcontroller
def google_oauth2
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)

      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"

        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.google_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
  end

*add this code in user.rb file
def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    unless user
        user = User.create(name: data["name"],
             email: data["email"],
             uid: access_token.uid,
             provider: access_token.provider,
             password: Devise.friendly_token[0,20]
            )
    end
    user
end

*inconfig/initilise/devise.rb add this
#for gmail account
require "omniauth-google-oauth2"
config.omniauth :google_oauth2, ENV['gmail_KEY'], ENV['gmail_SECRET'], { access_type: "offline", approval_prompt: "" }

13) to add omniauth for twwiter
*add gem 'omniauth-twitter'
then bundle install









