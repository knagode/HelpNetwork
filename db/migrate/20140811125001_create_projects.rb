class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.text :content
      t.string :url
      t.string :itunes_url
      t.string :google_url
      t.string :status
      t.timestamps
    end

    add_index :projects, :created_at
    add_index :projects, :status
  end
end
