class EnlargeNextSerialForCertificateAuthorities < ActiveRecord::Migration
  def change
    change_column :certificates, :next_serial, :numeric, precision: 20
  end
end
