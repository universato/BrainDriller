class AddIndexToDrill < ActiveRecord::Migration[6.1]
  def change
    add_index :drills, [:user_id, :title], unique: true
  end
end
