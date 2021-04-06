heroku login
heroku logs
git push heroku main
(git phm)

`heroku run rake db:migrate`


本番DBをふっとばす秘技。
`$ heroku run RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:drop`

`heroku pg:reset -a [アプリ名]` 確認を求められるので、アプリ名を入れる。
`heroku pg:reset --confirm [アプリ名]` 確認を省略できる。


`heroku pg:psql`
`\t` テーブル一覧
`quit` 終了
