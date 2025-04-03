class CreateRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :requests do |t|
      t.string :uid
      t.string :ip
      t.string :method
      t.string :url
      t.json :parameters

      t.timestamps
    end
    add_index :requests, :uid, unique: true
  end
end
