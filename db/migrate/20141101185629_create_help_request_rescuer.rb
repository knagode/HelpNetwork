class CreateHelpRequestRescuer < ActiveRecord::Migration
  def change
    create_table :help_request_rescuers do |t|
      t.integer :user_id
      t.integer :help_request_id
      t.string :state
      t.text :description
      t.decimal :latitude
      t.decimal :longitude
      t.integer :distance
      t.timestamps
    end
  end
end
