class Policy < ActiveRecord::Base
  has_many :subject_attributes, dependent: :destroy
  has_many :certificate_authority, dependent: :restrict_with_error
end
