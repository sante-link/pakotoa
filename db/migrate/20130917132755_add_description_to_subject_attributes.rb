# frozen_string_literal: true

class AddDescriptionToSubjectAttributes < ActiveRecord::Migration[4.2]
  def change
    add_column :subject_attributes, :description, :string
  end
end
