RuboCopの設定
エラーの影響範囲が大きいCopを無効化して、個別のエラーがでる自動生成のファイル等を無効化した。
```yml
AllCops:
  Exclude:
    - Gemfile
    - bin/*
    - config/environments/production.rb
    - config/initializers/filter_parameter_logging.rb
    - config/puma.rb
    - db/schema.rb
    - node_modules/**/*
    - vendor/**/*
  NewCops: enable

Style/ClassAndModuleChildren:
  Enabled: false
Style/Documentation:
  Enabled: false
Style/FrozenStringLiteralComment:
  Enabled: false
Style/StringLiterals:
  Enabled: false
```

ここでコミット。

Gemfileに`gem "devise"`を追記して、`budnle install`
`rails generate devise:install`
`rails db:migrate`
`rails generate devise:views`
`rails g devise:controllers users` ← これ必要だったかな？
`rails generate devise User`

あと、メールの設定をしたり、ビューを追加するなどした。
ログイン失敗時とか飛ぶときのために、rootも設定する必要あり。

http://localhost:3000/rails/info/routes#
http://localhost:3000/users/sign_in
http://localhost:3000/users/sign_up

```rb
User.column_names
#=> ["id", "email", "encrypted_password", "reset_password_token", "reset_password_sent_at", "remember_created_at", "created_at", "updated_at"]
```

`rails generate migration AddNamesToUsers`

```rb
class AddNamesToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :nickname, :string
    add_column :users, :login_name, :string
    add_index :users, :login_name
  end
end
```

`rails db:migrate`

deviseで詰まって立ち上げ直す。
$ rails s
=> Booting Puma
=> Rails 6.1.3 application starting in development
=> Run `bin/rails server --help` for more startup options
Exiting
~/rails/BrainDriller/vendor/bundle/ruby/3.0.0/gems/actionpack-6.1.3/lib/action_dispatch/routing/route_set.rb:587:in `add_route': Invalid route name, already in use: 'new_user_session'  (ArgumentError)
↓
`config.rb`に`devise_for :users`を2回書いてた。
なんか「自動で定義されないだっけ」って1番下に追記したけど、1番上に自動で追記されてた。

`rails webpacker:install:vue`

`rails g model UserProblemRelation`

[RailsでBootstrapとFont\-AwesomeはWebpackerで今時っぽく使おう \- Qiita](https://qiita.com/rhistoba/items/f724dae231d7e28bf477)
`yarn add bootstrap jquery popper.js`
`yarn add @fortawesome/fontawesome-free`

[Bootstrap4でFont Awesomeを使う\(3のGlyphiconsが使えなくなりました\) \- fv17の日記 \- Coding Every Day](https://forest-valley17.hatenablog.com/entry/2018/12/28/154908)
> Bootstrap4では、Bootstrap3で使えたGlyphiconsが使えなくなり有料化されました。代替案の一つが、Font Awesomeへの移行です。その方法を書きます

`<span aria-hidden='true' class='glyphicon glyphicon-user'></span>`
↓
`<i class="far fa-user"></i>`

`sticky-top`クラス bootstrap4


```rb
class Drill < ApplicationRecord
  enum state: { draft: 0, limited_open: 100, full_open: 200 }
end
```
↓
```
You tried to define an enum named "state" on the model "Drill", but this will generate a class method "public", which is already defined by Active Record.
```

`private`や`public`が予約語みたいな感じで使えないみたい。


Deviseにはない。
`logged_in?` -> `user_signed_in?`
`login_path` -> `user_new_session_path`


```
 Showing ~/rails/BrainDriller/app/views/drills/index.html.erb where line #15 raised:

Association named 'drill_problems' was not found on Drill; perhaps you misspelled it?
```
↓
```rb
@drills = Drill.order(created_at: "DESC").page(params[:page]).includes(:drill_problems)
```

```
undefined method `problems' for #<Drill id: 10, user_id: 1, title: "タイトルだよ", guide: "ガイドだよ", state: "full_open", number_of_views: 0, created_at: "2021-03-17 19:55:09.295876000 +0000", updated_at: "2021-03-17 19:55:09.295876000 +0000">
```
↓
`has_many :problems`

```
SQLite3::SQLException: no such column: problems.drill_id
```
↓
`belongs_to :drill`
SQL側のエラーで、

```rb
t.references :drills foreign_key: true, null: false
```
これ誤って複数形にしてたぽい。`t.belongs_to`でも同じらしい。

`ActiveModel::UnknownAttributeError: unknown attribute 'user' for Problem.`
モデル側でのエラーっぽい。

`has_many :problems`があるのに、`drill.problems`で`NoMethodError`がでた。コンソールを立ち上げ直す。


APIで`def show`と原形にすべきところを誤って3人称単数形にしてたら、エラーにならず素通りした。謎。
```ruby

```

`index.json.jbuilder`と書かずに`index.jbuilder`と書くと、URLでアクセスするときに`.json`をつけなくてもhtmlでアクセスしてしまうのか、見れてしまう。いいことか悪いことかよくわからない。

```rb
ActiveRecord::SubclassNotFound: The single-table inheritance mechanism failed to locate the subclass: 'basic_choices'. This error is raised because the column 'type' is reserved for storing the class in case of inheritance. Please rename this column if you didn't intend it to be used for storing the inheritance class or overwrite Problem.inheritance_column to use another column for that information.
```
