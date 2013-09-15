class CreateObjectIds < ActiveRecord::Migration
  def change
    create_table :object_ids do |t|
      t.string :name
      t.string :short_name
      t.string :oid

      t.timestamps
    end
  end
end
