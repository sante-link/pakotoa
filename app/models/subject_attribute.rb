class SubjectAttribute < ActiveRecord::Base
  acts_as_list

  validates :oid, presence: true
  validates :policy, presence: true
  validate :default do
    validates_length_of :default, minimum: min, allow_blank: true if min
    validates_length_of :default, maximum: max, allow_blank: true if max
  end
  validates :strategy, inclusion: [ 'match', 'optional', 'supplied' ], presence: true
  validates_associated :oid, :policy

  belongs_to :oid
  belongs_to :policy

  before_save do
    self.description = oid.default_description if self.description.blank?
  end
end
