# frozen_string_literal: true

class CreateCertificates < ActiveRecord::Migration[4.2]
  def change
    create_table :certificates do |t|
      t.string :serial
      t.references :authority, index: true

      t.timestamps
    end
  end
end
