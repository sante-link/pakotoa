class RenameSubjectAttributesObjectIdIdToOidId < ActiveRecord::Migration
  def change
    rename_column :subject_attributes, :object_id_id, :oid_id
  end
end
