# frozen_string_literal: true

class AddCommittedToAuthorities < ActiveRecord::Migration[4.2]
  def change
    add_column :authorities, :committed, :boolean, default: false
  end
end
