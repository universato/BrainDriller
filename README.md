# README

**Braindriller** は、**すでに理解をし解くことができた問題と、理解が足りず解けなかった問題を分ける手間をなくしたい**、**学習者**向けの**問題作成&&学習サービス**です。
**ユーザーは問題の作成と、それらの問題に答えることができ、解けたか、解けなかったがの結果で問題の仕分けがされ**、**ダウンロード不要でサービスを利用することができること**が特徴です。

# URL

- https://brain-driller.herokuapp.com (SSL)
- http://brain-driller.com

## Ruby version

3.0.2

## Links

[memo-db](READMES/memo-db.md)
[memo-heroku](READMES/memo-heroku.md)
[memoraundum](READMES/memorandum.md)

# テスト方法

```r
rails t
rails t test/system/drills_test.rb:23
```

```s
rails test:all
HEADED=1 rails test:all
```

`HEADED=1`で、ブラウザで描画してテストする。

# サーバーを立ち上げる

```s
rails s
rails server 
```

```s
./bin/webpack-dev-server
bin/webpack-dev-server
```

`bin`ディレクトリ内に入っているRubyコードを呼んでいる。

# DB

PostgreSQLを使用。

```s
rails db:setup
```

db:reset
  - db:drop
  - db:setup
    - db:create
    - db:migrate
    - db:seed

# yarn

npmではなく、yarnを使用。

```s
yarn install
```
