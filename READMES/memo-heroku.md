```s
heroku login
heroku logs
git push heroku main
git phm
```

```s
heroku run rake db:migrate
heroku run rake db:seed
```

本番DBをふっとばす秘技。
```r
heroku run RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:drop
```

```r
$ heroku run RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:drop
Running RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:drop on ⬢ brain-driller... up, run.6246 (Free)
Database 'd8tkj36q8g3jtv' does not exist
```

`heroku run`が、herokuにコマンドを叩かせるコマンド。
`RAILS_ENV=production` RAILSの環境をproductionに設定。
`DISABLE_DATABASE_ENVIRONMENT_CHECK=1` なんだろう。

`heroku pg:reset --confirm [アプリ名]` 確認を省略できる。
`heroku pg:reset -a [アプリ名]` 確認を求められるので、アプリ名を入れる。

`heroku pg:psql`
`\t` テーブル一覧
`quit` 終了
`SELECT COUNT(*) FROM users;` ユーザー数を確かめる。

```sql
SELECT COUNT(*) FROM users;
SELECT email, encrypted_password FROM users;
```

# 

https://dashboard.heroku.com/login

# 作り直し

例
```
heroku create アプリ名
git push heroku main
```

1ユーザーにつき、無料でHerokuに5つアプリケーションを登録できる。
`heroku create アプリ名`で、アプリ名を指定してherokuにWebアプリを入れる箱を作る。

具体例
```
heroku create brain-driller
git push heroku main
```
remote: Verifying deploy... done.
To https://git.heroku.com/brain-driller.git
 * [new branch]      main -> main

We're sorry, but something went wrong.
↓

```
heroku addons:add heroku-postgresql
heroku run rake db:create
```

```
$ heroku run rake db:create
Running rake db:create on ⬢ brain-driller... up, run.2074 (Free)
FATAL:  permission denied for database "postgres"
DETAIL:  User does not have CONNECT privilege.
Couldn't create 'd8tkj36q8g3jtv' database. Please check your configuration.
rake aborted!
ActiveRecord::NoDatabaseError: FATAL:  permission denied for database "postgres"
DETAIL:  User does not have CONNECT privilege.
```
