class AddNextSerialToCertificateAuthority < ActiveRecord::Migration
  def change
    add_column :certificates, :next_serial, :integer
  end
end
