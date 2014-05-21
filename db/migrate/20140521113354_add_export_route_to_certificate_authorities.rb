class AddExportRouteToCertificateAuthorities < ActiveRecord::Migration
  def change
    add_column :certificates, :export_root, :string
  end
end
