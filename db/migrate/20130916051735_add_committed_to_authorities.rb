class AddCommittedToAuthorities < ActiveRecord::Migration
  def change
    add_column :authorities, :committed, :boolean, default: false
  end
end
