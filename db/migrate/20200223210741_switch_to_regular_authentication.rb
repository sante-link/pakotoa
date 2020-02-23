class SwitchToRegularAuthentication < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :provider
    remove_column :users, :uid

    add_column :users, :encrypted_password, :string, null: false, default: ''

    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime

    add_column :users, :remember_created_at, :datetime

    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string
  end
end
