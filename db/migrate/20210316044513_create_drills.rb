# frozen_string_literal: true
class CreateDrills < ActiveRecord::Migration[6.1]
  def change
    create_table :drills do |t|
      t.references :user, foreign_key: true, null: false
      t.string :title, null: false, default: ""
      t.string :guide, null: false, default: ""
      t.integer :state, null: false, default: 0 # require_relative "app/models/drill.rb"
      t.integer :number_of_views, unsigned: true, null: false, default: 0

      t.timestamps
    end
  end
end

# 作成者ID ≒ 管理者ID。
# 管理者はデフォルトで作成者だが、作成者が別の人に管理権限を委譲できるとしたら?

# 誰でも編集できるかどうかも決めたいな。true or false で良いのか。
# オープン問題は、投票で排除できる仕組みがあると良いと思う。
# 公式かどうか。オープンかどうか。
