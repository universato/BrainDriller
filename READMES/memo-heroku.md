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
`$ heroku run RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:drop`

`heroku pg:reset -a [アプリ名]` 確認を求められるので、アプリ名を入れる。
`heroku pg:reset --confirm [アプリ名]` 確認を省略できる。

`heroku pg:psql`
`\t` テーブル一覧
`quit` 終了


# 作り直し

```
heroku create アプリ名
git push heroku main
```

1ユーザーにつき、無料でHerokuに5つアプリケーションを登録できる。
`heroku create アプリ名`で、アプリ名を指定してherokuにWebアプリを入れる箱を作る。

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
