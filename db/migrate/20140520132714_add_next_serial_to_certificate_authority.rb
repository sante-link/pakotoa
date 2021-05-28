# frozen_string_literal: true

class AddNextSerialToCertificateAuthority < ActiveRecord::Migration[4.2]
  def change
    add_column :certificates, :next_serial, :integer
  end
end
