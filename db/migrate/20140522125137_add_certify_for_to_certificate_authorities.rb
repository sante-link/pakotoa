class AddCertifyForToCertificateAuthorities < ActiveRecord::Migration[4.2]
  def change
    add_column :certificates, :certify_for, :string, default: '2 years from now'
  end
end
