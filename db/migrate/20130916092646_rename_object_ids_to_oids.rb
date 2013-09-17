class RenameObjectIdsToOids < ActiveRecord::Migration
  def change
    rename_table :object_ids, :oids
  end
end
