class Authority < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :affiliations
  has_many :users, through: :affiliations
  has_many :certificates, dependent: :destroy
end
