class AddProblemSizeToDrills < ActiveRecord::Migration[6.1]
  def change
    add_column :drills, :problem_size, :integer, null: false, default: 0
  end
end
