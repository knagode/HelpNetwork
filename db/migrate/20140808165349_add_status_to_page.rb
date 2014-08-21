class AddStatusToPage < ActiveRecord::Migration
  def change
    add_column :pages, :status, :string
    add_column :pages, :visible_in_menu, :boolean
  end
end
