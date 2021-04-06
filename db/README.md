# `rails db`

`.q`で脱出。


`rails db:seed`

`rails db:drop`
`rails db:reset`


`rails db:migrate`
`rails db:migrate:status`
`rails db:migrate:reset`

# rails --tasks | grep db:

```
rails --tasks | grep db:
```

`rails db:reset`が良いかもしれない。
マイグレートからやり直す。

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
