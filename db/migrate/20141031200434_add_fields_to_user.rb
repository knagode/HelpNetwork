class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :lastname, :string
    add_column :users, :firstname, :string
    add_column :users, :name, :string
    add_column :users, :sex, :string
    add_column :users, :birthday, :date
    add_column :users, :password_reset_token, :string
    add_column :users, :password_reset_sent_at, :datetime
    add_column :users, :email_verified, :boolean, default: false, null: false
    add_column :users, :email_verification_token, :string
    add_column :users, :email_verification_sent_at, :datetime
    add_column :users, :email_verified_at, :datetime
  end
end
