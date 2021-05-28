# frozen_string_literal: true

class EnlargeNextSerialForCertificateAuthorities < ActiveRecord::Migration[4.2]
  def change
    change_column :certificates, :next_serial, :numeric, precision: 20
  end
end
