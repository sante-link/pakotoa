class UpdateDoorkeeperTables < ActiveRecord::Migration[6.0]
  def change
    add_column :oauth_applications, :scopes, :string, null: false, default: ''
    add_column :oauth_applications, :confidential, :boolean, null: false, default: true

    change_column :oauth_access_grants, :scopes, :string, { null: false, default: ''}
    add_foreign_key(
      :oauth_access_grants,
      :oauth_applications,
      column: :application_id
    )

    add_column :oauth_access_tokens, :previous_refresh_token, :string, null: false, default: ''

    add_foreign_key(
      :oauth_access_tokens,
      :oauth_applications,
      column: :application_id
    )

    # Uncomment below to ensure a valid reference to the resource owner's table
    add_foreign_key :oauth_access_grants, :users, column: :resource_owner_id
    add_foreign_key :oauth_access_tokens, :users, column: :resource_owner_id
  end
end
