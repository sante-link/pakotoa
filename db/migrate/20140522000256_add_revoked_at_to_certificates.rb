# frozen_string_literal: true

class AddRevokedAtToCertificates < ActiveRecord::Migration[4.2]
  def change
    add_column :certificates, :revoked_at, :datetime
  end
end
