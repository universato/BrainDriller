class CreateProblems < ActiveRecord::Migration[6.1]
  def change
    create_table :problems do |t|
      t.string :title, null: false
      t.references :user, foreign_key: true
      t.integer :problem_type, null: false
      t.json :choices, null: false
      t.text :explanation, null: false

      # t.text :correct1
      # t.text :incorrect1
      # t.text :incorrect2
      # t.text :incorrect3

      # # 2つ以上、必要
      # # 正誤問題だけなら、正解カラムにtrue or falseだけでも良さそう。
      # t.text :option0
      # t.text :option1
      # t.text :option2
      # t.text :option3
      # t.text :option4
      # t.text :option5
      # t.integer :correct_option_number

      # t.string :tag0
      # t.string :tag1
      # t.string :tag2
      # t.string :tag3
      # t.string :tag4
      # t.string :tag5

      t.integer :impressions_count, default: 0, null: false

      # number_ofの方が、_countよりもサジェストが効きやすいかもしれない。並べるから。
      # 閲覧回数(のべ閲覧人数) :number_of_views, (=opens)
      # 提出回数(のべ提出者数) :number_of_submissions,
      # 正解回数(のべ正解者数) :total_number_of_ansewers, correct_answers
      # 回数による正解率、最大数は100であり、1バイト = -128 ~ 127
      t.integer :number_of_views, default: 0, unsigned: true, null: false
      t.integer :number_of_submissions, default: 0, unsigned: true, null: false
      t.integer :number_of_correct_answers, default: 0, unsigned: true, null: false
      t.integer :correct_answer_rate,  default: nil, limit: 1, null: false

      # 何をもって正解とするのか。最後の質問での正解者数か。それとも初回正解者数か。
      # 重複なしの閲覧人数 :number_of_viewers (=openers)
      # 重複なしの提出者数 :number_of_submitters(=respondents)
      # 重複なしの正解者数 :number_of_correcers, number_of_answers
      # 重複なしの正解者数 :number_of_last_shot_answerers, number_of_answers
      # 重複なしの正解者数 :number_of_one_shot_answerers, number_of_answers

      # 人数による正解率
      t.integer :number_of_viewers,    default: 0, unsigned: true, null: false
      t.integer :number_of_submitters, default: 0, unsigned: true, null: false
      t.integer :number_of_one_shot_answerers, default: 0, unsigned: true, null: false
      t.integer :number_of_last_shot_answerers, default: 0, unsigned: true, null: false
      # t.integer :number_of_respondents, default: 0, unsigned: true
      # t.integer :, default: 0, unsigned: true, null: false
      t.integer :correct_people_rate,  default: nil, limit: 1, null: false

      t.integer :questioner, null: false
      t.boolean :open, default: false, null: false
      t.boolean :in_order, default: true, null: false

      t.timestamps
    end

    create_table :basic_choices do |t|
      t.json :choices, null: false
      t.integer :correct_number, default: 0, null: false
    end
  end
end

# rake log migrate:db

# CREATE TABLE "problems" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar NOT NULL, "problem_type" integer NOT NULL, "explanation" text NOT NULL, "number_of_views" integer DEFAULT 0 NOT NULL, "number_of_submissions" integer DEFAULT 0 NOT NULL, "number_of_correct_answers" integer DEFAULT 0 NOT NULL, "correct_answer_rate" integer(1) NOT NULL, "number_of_viewers" integer DEFAULT 0 NOT NULL, "number_of_submitters" integer DEFAULT 0 NOT NULL, "number_of_one_shot_answerers" integer DEFAULT 0 NOT NULL, "number_of_last_shot_answerers" integer DEFAULT 0 NOT NULL, "correct_people_rate" integer(1) NOT NULL, "questioner" integer NOT NULL, "open" boolean DEFAULT 0 NOT NULL, "in_order" boolean DEFAULT 1 NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL)

# CREATE TABLE "basic_choices" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "options" text NOT NULL, "correct_number" integer DEFAULT 0 NOT NULL)


# 正誤問題 true or false 正解がどっちか(true or false)
# 選択肢問題
#   択一式 vs 複数選択
# 択一式 ← 正解が何か。

# 選択肢問題
# 正解番号:n, [選択肢1, 選択肢2, 選択肢3]
# 複数選択
# 正解番号:[1, 2], [選択肢1, 選択肢2, 選択肢3]

# [クイズアプリにおけるデータベース設計のアンチパターン \- Qiita]
# (https://qiita.com/kumackey/items/7ccbc949458bd0af22bd)


# rails db:rollback

# psql -l
# createdb quiz_lab
# psql quiz_lab

# create table problems (title varchar(255), body text, problem_type integer);
# create table basic_choices ()

# \l
# \dt

# わからないことは何か。最適なDB構成
