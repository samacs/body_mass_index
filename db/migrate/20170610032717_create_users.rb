class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, limit: 128
      t.string :password_digest, limit: 72
      t.string :name, limit: 128

      t.timestamps
    end
  end
end
