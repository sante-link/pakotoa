# frozen_string_literal: true

class AddExportRouteToCertificateAuthorities < ActiveRecord::Migration[4.2]
  def change
    add_column :certificates, :export_root, :string
  end
end
