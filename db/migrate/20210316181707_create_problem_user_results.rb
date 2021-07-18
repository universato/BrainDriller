# frozen_string_literal: true

class CreateProblemUserResults < ActiveRecord::Migration[6.1]
  def change
    create_table :problem_user_results do |t|
      t.references :user,    index: true, foreign_key: true
      t.references :problem, index: true, foreign_key: true

      t.integer :number_of_views, default: 0, unsigned: true
      t.integer :number_of_submissions, default: 0, unsigned: true
      t.integer :current_streak, default: 0, unsigned: true
      # t.integer :number_of_answers
      t.integer :number_of_correct_answers, default: 0, unsigned: true

      t.timestamps
    end

    add_index :problem_user_results, [:user_id, :problem_id], unique: true
  end
end
