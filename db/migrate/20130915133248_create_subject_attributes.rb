# frozen_string_literal: true

class CreateSubjectAttributes < ActiveRecord::Migration[4.2]
  def change
    create_table :subject_attributes do |t|
      t.references :object_id, index: true
      t.references :authority, index: true
      t.string :default
      t.integer :min
      t.integer :max
      t.string :policy
      t.integer :position

      t.timestamps
    end
  end
end
