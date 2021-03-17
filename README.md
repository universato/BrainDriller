# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

3.0.0

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

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
