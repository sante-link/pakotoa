# frozen_string_literal: true

class RenameAuthoritiesToCertificateAuthorities < ActiveRecord::Migration[4.2]
  def change
    rename_table :authorities, :certificate_authorities
    rename_column :affiliations, :authority_id, :certificate_authority_id
    rename_column :certificates, :authority_id, :certificate_authority_id
    rename_column :subject_attributes, :authority_id, :certificate_authority_id
  end
end
