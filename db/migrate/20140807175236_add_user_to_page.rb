class AddUserToPage < ActiveRecord::Migration
  def change
    add_column :pages, :user_id, :integer
    add_column :pages, :published_at, :datetime
  end
end
