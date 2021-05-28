# frozen_string_literal: true

class CreatePolicies < ActiveRecord::Migration[4.2]
  def change
    create_table :policies do |t|
      t.string :name
    end

    # Existing data would be broken
    SubjectAttribute.delete_all

    add_column :certificates, :policy_id, :integer
    rename_column :subject_attributes, :certificate_authority_id, :policy_id
    rename_column :subject_attributes, :policy, :strategy
  end
end
