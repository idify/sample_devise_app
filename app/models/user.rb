class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  #  and 
# has_many :authentications

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable, :timeoutable, :omniauthable ,:omniauth_providers => [:facebook,:google_oauth2,:twitter]#, :omniauth_providers => []

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:provider, :uid, :name
  # attr_accessible :title, :body
 # validate :email_required?, :if => :provider
  # validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :if => :email_changed?
  # to customise timeoutable
  def timeout_in
  60.seconds
  
  end

#  def email_required?
#    super && provider.blank?
#  end

  def email_changed?
   if self.provider
     false
   else
    true
   end
  end

 #for facebook account
    def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
    end

  def self.find_for_facebook_oauth(auth)
  user = User.find_by_email(auth.info.email)
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
 #for gmail account
 #devise :omniauthable, :omniauth_providers => [:google_oauth2]

def self.find_for_google_oauth2(access_token)
    data = access_token.info
    user = User.find_by_email(data["email"])

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

#for twitter
  def self.find_for_twitter_oauth(access_token)
    data = access_token.info
    user = User.find_by_provider_and_uid(access_token['provider'], access_token['uid'])

    unless user
        user = User.create(name: data["name"],
             email: data["name"],
             uid: access_token.uid,
             provider: access_token.provider,
             password: Devise.friendly_token[0,20]
            )
    end
    user
  end


end
