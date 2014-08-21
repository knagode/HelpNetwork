class AddImageToProjects < ActiveRecord::Migration
  def self.up
    add_attachment :projects, :image
  end

  def self.down
    remove_attachment :projects, :image
  end
end
