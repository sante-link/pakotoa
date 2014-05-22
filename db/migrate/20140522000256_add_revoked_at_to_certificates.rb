class AddRevokedAtToCertificates < ActiveRecord::Migration
  def change
    add_column :certificates, :revoked_at, :datetime
  end
end
