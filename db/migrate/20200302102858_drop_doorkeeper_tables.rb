# frozen_string_literal: true

class DropDoorkeeperTables < ActiveRecord::Migration[6.0]
  def up
    drop_table :oauth_applications
    drop_table :oauth_access_grants
    drop_table :oauth_access_tokens
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
