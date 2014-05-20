class SubjectAttribute < ActiveRecord::Base
  acts_as_list

  validates :oid, presence: true
  validates :certificate_authority, presence: true
  validate :default do
    validates_length_of :default, minimum: min, allow_blank: true if min
    validates_length_of :default, maximum: max, allow_blank: true if max
  end
  validates :policy, inclusion: [ 'match', 'optional', 'supplied' ], presence: true
  validates_associated :oid, :certificate_authority

  belongs_to :oid
  belongs_to :certificate_authority

  before_save do
    self.description = oid.default_description if self.description.blank?
  end
end
