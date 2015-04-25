class AddSetupFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :who_am_i, :text
    add_column :users, :sign_up_reason, :text
    add_column :users, :locations, :text
  end
end
