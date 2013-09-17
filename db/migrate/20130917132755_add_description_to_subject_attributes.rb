class AddDescriptionToSubjectAttributes < ActiveRecord::Migration
  def change
    add_column :subject_attributes, :description, :string
  end
end
