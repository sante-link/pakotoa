class Authority < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :basename, presence: true, uniqueness: true

  has_many :affiliations, dependent: :destroy
  has_many :users, through: :affiliations
  has_many :certificates, dependent: :destroy
  has_many :subject_attributes, dependent: :destroy

  def directory
    Rails.root.join('config', 'ssl', "#{id}.#{basename}")
  end
end
