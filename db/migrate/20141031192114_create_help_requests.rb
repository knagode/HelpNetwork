class CreateHelpRequests < ActiveRecord::Migration
  def change
    create_table :help_requests do |t|
      t.integer :user_id
      t.text :description
      t.decimal :latitude
      t.decimal :longitude
      t.string :state
      t.timestamps
    end
  end
end
