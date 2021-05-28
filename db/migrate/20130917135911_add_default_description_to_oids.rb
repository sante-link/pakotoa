# frozen_string_literal: true

class AddDefaultDescriptionToOids < ActiveRecord::Migration[4.2]
  def change
    add_column :oids, :default_description, :string
  end
end
