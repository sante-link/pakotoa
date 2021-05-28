# frozen_string_literal: true

class CreateAffiliations < ActiveRecord::Migration[4.2]
  def change
    create_table :affiliations do |t|
      t.references :user, index: true
      t.references :authority, index: true

      t.timestamps
    end
  end
end
