class CreateDrills < ActiveRecord::Migration[6.1]
  def change
    create_table :drills do |t|
      t.string :title
      t.integer :number_of_views, unsigned: true, null: false, default: 0
      t.references :user, foreign_key: true

      enum state: { draft: 0, private: 100, public: 200 }

      t.timestamps
    end
  end
end

# 作成者ID ≒ 管理者ID。
# 管理者はデフォルトで作成者だが、作成者が別の人に管理権限を委譲できるとしたら?

# 誰でも編集できるかどうかも決めたいな。true or false で良いのか。
# オープン問題は、投票で排除できる仕組みがあると良いと思う。
# 公式かどうか。オープンかどうか。
