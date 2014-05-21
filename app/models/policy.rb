class Policy < ActiveRecord::Base
  has_many :subject_attributes
  has_many :certificate_authority
end
