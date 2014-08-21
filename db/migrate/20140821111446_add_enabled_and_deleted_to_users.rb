class AddEnabledAndDeletedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :deleted, :boolean, default: false, null: false
    add_column :users, :enabled, :boolean, default: true, null: false
  end
end
