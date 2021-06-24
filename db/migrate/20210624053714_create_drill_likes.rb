class CreateDrillLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :drill_likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :drill, null: false, foreign_key: true

      t.timestamps
    end
    add_index :drill_likes, [:user_id, :drill_id], unique: true
  end
end
