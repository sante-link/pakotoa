class AddDefaultDescriptionToOids < ActiveRecord::Migration
  def change
    add_column :oids, :default_description, :string
  end
end
