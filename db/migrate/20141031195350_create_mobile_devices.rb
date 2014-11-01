class CreateMobileDevices < ActiveRecord::Migration
  def change
    create_table :mobile_devices do |t|
      t.string :model, limit: 255
      t.string :system_name, limit: 255
      t.string :system_version, limit: 255
      t.boolean  :multitasking, default: false, null: false
      t.integer :user_id, :integer
      t.timestamps
    end
  end
end
