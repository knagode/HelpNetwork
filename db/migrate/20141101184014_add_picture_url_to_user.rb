class AddPictureUrlToUser < ActiveRecord::Migration
  def change
    add_column :users, :picture_url, :string
    add_column :users, :facebook_id, :string
    add_column :users, :google_id, :string
  end
end
