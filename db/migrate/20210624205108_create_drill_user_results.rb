class CreateDrillUserResults < ActiveRecord::Migration[6.1]
  def change
    create_table :drill_user_results do |t|
      t.references :user, null: false, foreign_key: true
      t.references :drill, null: false, foreign_key: true
      t.integer :number_of_problem_mastered, default: 0, null: false

      t.timestamps
    end
    add_index :drill_user_results, [:user_id, :drill_id], unique: true
  end
end
