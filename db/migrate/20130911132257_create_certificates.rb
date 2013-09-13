class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
      t.string :serial
      t.references :authority, index: true

      t.timestamps
    end
  end
end
