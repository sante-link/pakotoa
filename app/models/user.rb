class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable
  devise :trackable, :omniauthable, omniauth_providers: [:medispo]

  def self.find_for_medispo_oauth(auth, signed_in_resource=nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    if user.nil? then
      user = User.create(provider: auth.provider, uid: auth.uid, email: auth.info.email)
    end
    user
  end

  has_many :affiliations
  has_many :authorities, through: :affiliations
end
