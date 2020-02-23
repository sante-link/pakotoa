class Oid < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_many :subject_attributes
end
