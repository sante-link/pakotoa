# frozen_string_literal: true

class ReworkDataModel < ActiveRecord::Migration[4.2]
  def change
    drop_table :certificate_authorities

    rename_column :certificates, :certificate_authority_id, :issuer_id

    add_column :certificates, :type, :string, default: "Certificate"
    add_column :certificates, :subject, :string
    add_column :certificates, :certificate, :text
    add_column :certificates, :not_before, :datetime
    add_column :certificates, :not_after, :datetime

    add_column :certificates, :key, :text
  end
end
