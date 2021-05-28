# frozen_string_literal: true

class RemoveOmniauthableFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :uid, :string
    remove_column :users, :provider, :string
    add_column :users, :encrypted_password, :string, null: false, default: ""
  end
end
