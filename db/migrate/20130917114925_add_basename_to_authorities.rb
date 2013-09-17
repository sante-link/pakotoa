class AddBasenameToAuthorities < ActiveRecord::Migration
  def change
    add_column :authorities, :basename, :string
  end
end
