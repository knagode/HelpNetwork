class CreateAuthenticationTokens < ActiveRecord::Migration
  def change
    create_table :authentication_tokens do |t|
      t.string :token, limit: 255
      t.integer :user_id

      t.timestamps
    end
  end
end
