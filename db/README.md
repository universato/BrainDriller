# Links

[memo-db.md](../memo-db.md)

# `rails db`

`.q`で脱出。

```r
rails db:seed

rails db:drop
rails db:reset

rails db:migrate
rails db:migrate:status
rails db:migrate:reset
```

# rails --tasks | grep db:

```
rails --tasks | grep db:
```

`rails db:reset`が良いかもしれない。
マイグレートからやり直す。seedもする。これ、本当にmigrateからやり直してる？ してない気がする。

`rails db:drop`をすると、テーブルを削除してしまう。
`rails db:migrate`からやり直す必要がある。

ユーザー
ドリル
問題
の順番に作るのがDB的にはいいかもしれない。


### Rakefile

```ruby
# [Rails・seedファイルを分割して管理する \- Qiita](https://qiita.com/masaki7555/items/d65f56958020cbca5ee0)
# bundle exex rake db:seed:user
Pathname.glob(Rails.root.join('db/seeds/*.rb')) do |path|
  desc("Load the seed data from db/seeds/#{path.basename}")
  task("db:seed:#{path.basename('.*')}"  => :environment){ load(path) }
  task("db:seeds:#{path.basename('.*')}" => :environment){ load(path) }
end
```

これ書いたけど、`require_relative`を使えば、`ruby db/seeds/user.rb`と一緒かな。
`Rails.root`は、`#<Pathname:/Users/uni/rails/[アプリ名]>`を返す。
`Rails.root.join('db/seeds/*.rb')`は、`#<Pathname:/Users/uni/rails/[アプリ名]/db/seeds/*.rb>`を返す。
`Pathname.glob(Rails.root.join('db/seeds/*.rb'))`が、`Pathname`クラスの`db:seeds/`以下にあるRubyファイルを回す。
`Pathname#basename('.*')`で、(拡張子を除いた)ファイル名のところをとれる。
`:enviroment`がよくわからない。
`Rails.root`以外はRubyコアにある感じだと思う。


# migrate

[Railsガイド](https://railsguides.jp/active_record_migrations.html)
```
rails g migration AddPartNumberToProducts
rails g migration AddPartNumberToProducts part_number:string
```

## 

```rb
Drill.find_by(title: "Ruby").id
ids = Drill.find_by(title: "Ruby").problems.pluck(:id) # => Array(Integer)
u = User.find(1)
relations = UserProblemRelation.where(user_id: 1, problem_id: ids)
relations.to_h{ [_1.problem_id, _1] }
relations.to_h{ [_1.problem_id, _1] }.keys
```

### find

```rb
Actress.find([1, 2])
Actress.find(1, 2)
```

Railsの`find`は、1引数のIntegerだけでなく、配列も、可変長引数もOKなので、すごい。IDで検索する。

### take

```rb
Actress.take
```

### first

46191349
421530892

firstは数値で比較する感じだけど、それ以外は文字列で比較してる？ 関係なく、適当に取ってるのかも。

```rb
User.first.name # => "Yamada Taro"
User.first.id   # => 46191349
Creating scope :search_by_keywords_scope. Overwriting existing method User.search_by_keywords_scope.
  User Load (30.9ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT $1  [["LIMIT", 1]]
```

```rb
User.all[0].name # => "アドバイ 次郎"
User.all[0].id   # => 421530892
User Load (1.1ms)  SELECT "users".* FROM "users"
```

```rb
User.take.name # => "アドバイ 次郎"
  User Load (0.8ms)  SELECT "users".* FROM "users" LIMIT $1  [["LIMIT", 1]]
```

# Rails結合

[Rails における内部結合、外部結合まとめ \- Qiita](https://qiita.com/yuyasat/items/c2ad37b5a24a58ee3d30)

```rb
rails g model Actress name:string
rails g model Movie actress:references title:string year:integer
rails g model Tag movie:references key:string
```

単数形:referenceではなく,
複数形:references。なぜ複数形?


```rb
Actress.all.size   #              (0.4ms)  SELECT COUNT(*) FROM "actresses"
Actress.all.count  #              (0.3ms)  SELECT COUNT(*) FROM "actresses"
Actress.all.length # Actress Load (0.4ms)  SELECT "actresses".* FROM "actresses"
```

`count`の返り値は`Integer`みたいだし、必ず`COUNT(*)`を実行するみたい。

`Model` < `ApplicationRecord` < `ActiveRecord::Base`

```rb
ActiveRecord.joins(:テーブル名(複数駅)) #=> Model::ActiveRecord_Relation
Actress::ActiveRecord_Relation.select("actresses.*, movies.id AS movie_id") #=> Model::ActiveRecord_Relation
```

```rb
joins(:テーブル名(複数形))
left_joins
left_outer_joins
includes(:テーブル名(複数形))
.includes(movies: :tags)
.references(:tags)
.references(:movies, :tags)
eager_load(:テーブル名(複数形))
preload
.select("actresses.*, movies.*")
distinct
```

`joins`の引数は、テーブル名というか、関連名なのかな。結びつけてないといけない。

生SQL
```rb
Actress.methods.sort.grep(/by_sql/)
# => [:count_by_sql, :find_by_sql]

query = "SELECT id, title FROM movies WHERE actress_id = 4"
Movie.find_by_sql(query)
[#<Movie:0x00007f8269b565b0 id: 3, title: "ALWAYS 三丁目の夕日">,
 #<Movie:0x00007f8269b56290 id: 6, title: "県庁おもてなし課">]
```

`find_by_sql`のときに、レシーバのモデル名からテーブル名を推測できてもよさそうだが、
SQL文で、`FROM table_name`を書く必要がある。
あと、モデル名のインスタンスの配列が強制的に返る。すごい。テーブル名に関係なく返るので、すごい。

生SQLは、DBに左右されることになるので、DBを変更する際に、書き換える必要がでてくる。
Railsで書いてさえいれば、DBに左右されることはないはず。


```rb
reorder
reselect
rewhere
```

```rb
reverse_order
```

`reverse`じゃないのはRubyのメソッドでないことを強調するため。引数を取らないメソッドらしい。
