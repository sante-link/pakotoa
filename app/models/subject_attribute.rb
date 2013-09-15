class SubjectAttribute < ActiveRecord::Base
  acts_as_list

  belongs_to :object_id
  belongs_to :authority
end
