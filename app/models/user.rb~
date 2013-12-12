class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  #  and 
# has_many :authentications

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable, :timeoutable, :omniauthable ,:omniauth_providers => [:facebook,:google_oauth2, :twitter]#, :omniauth_providers => []

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:provider, :uid, :name
  # attr_accessible :title, :body
  
  # to customise timeoutable
  def timeout_in
  60.seconds
  
  end
 #for facebook account
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
 #for gmail account
 #devise :omniauthable, :omniauth_providers => [:google_oauth2]

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
#for gmail


def self.new_with_session(params, session)
  super.tap do |user|
    if data = session['devise.googleapps_data'] && session['devise.googleapps_data']['user_info']
      user.email = data['email']
    end
  end
end

# for twitter
 def self.find_for_twitter_oauth(omniauth)
      authentication = UserToken.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
      if authentication && authentication.user
        authentication.user
      else
        User.new
        # In a typical app you would create a new user here:
        # User.create!(:email => data['email'], :password => Devise.friendly_token[0,20]) 
      end
 end 
end
