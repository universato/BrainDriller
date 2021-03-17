class CreateUserProblemRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :user_problem_relations do |t|
      t.references :user,    index: true, foreign_key: true
      t.references :problem, index: true, foreign_key: true

      # t.integer :user_id, unsigned: true
      # t.integer :problem_id, unsigned: true

      t.integer :number_of_views, default: 0, unsigned: true
      t.integer :number_of_submissions, default: 0, unsigned: true
      # t.integer :number_of_answers
      t.integer :number_of_correct_answers, default: 0, unsigned: true
      t.integer :correct_answer_rate, default: 0, unsigned: true, limit: 1

      t.float :average_time
      t.float :first_time
      t.float :fastest_time

      t.timestamps
    end

    # add_index :user_problem_relations, :user_id
    # add_index :user_problem_relations, :problem_id
    add_index :user_problem_relations, [:user_id, :problem_id], unique: true
  end
end
