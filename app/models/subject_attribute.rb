class SubjectAttribute < ActiveRecord::Base
  acts_as_list

  validates :oid, presence: true
  validates :authority, presence: true
  validates :policy, inclusion: [ 'match', 'optional', 'supplied' ]
  validates_associated :oid, :authority

  belongs_to :oid
  belongs_to :authority

  before_save do
    self.description = oid.default_description if self.description.blank?
  end
end
