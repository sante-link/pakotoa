# frozen_string_literal: true

class CreateObjectIds < ActiveRecord::Migration[4.2]
  def change
    create_table :object_ids do |t|
      t.string :name
      t.string :short_name
      t.string :oid

      t.timestamps
    end
  end
end
