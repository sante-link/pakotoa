class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable
  devise :trackable, :omniauthable, omniauth_providers: [:medispo]

  def self.find_for_medispo_oauth(auth, signed_in_resource=nil)
    raise 'Not authorized' unless auth.extra[:raw_info][:roles].try(:include?, 'medispo_administrator')

    user = User.where(provider: auth.provider, uid: auth.uid.to_s).first
    if user.nil? then
      user = User.create(provider: auth.provider, uid: auth.uid.to_s, email: auth.info.email, time_zone: auth.info.time_zone)
    else
      user.update_attributes(time_zone: auth.info.time_zone)
    end
    user
  end

  has_many :affiliations
  has_many :certificate_authorities, through: :affiliations
end
