# frozen_string_literal: true

class AddBasenameToAuthorities < ActiveRecord::Migration[4.2]
  def change
    add_column :authorities, :basename, :string
  end
end
