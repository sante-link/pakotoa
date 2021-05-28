# frozen_string_literal: true

class RenameObjectIdsToOids < ActiveRecord::Migration[4.2]
  def change
    rename_table :object_ids, :oids
  end
end
