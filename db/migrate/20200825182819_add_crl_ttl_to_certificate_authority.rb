# frozen_string_literal: true

class AddCrlTtlToCertificateAuthority < ActiveRecord::Migration[6.0]
  def change
    add_column :certificates, :crl_ttl, :string, default: "1 week from now"
  end
end
