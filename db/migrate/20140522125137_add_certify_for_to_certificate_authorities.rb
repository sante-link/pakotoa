class AddCertifyForToCertificateAuthorities < ActiveRecord::Migration
  def change
    add_column :certificates, :certify_for, :string, default: '2 years from now'
  end
end
