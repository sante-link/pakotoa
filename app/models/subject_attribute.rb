class SubjectAttribute < ActiveRecord::Base
  acts_as_list

  belongs_to :oid
  belongs_to :authority
end
