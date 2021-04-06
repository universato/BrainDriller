heroku login
heroku logs
git push heroku main
(git phm)

`heroku run rake db:migrate`


本番DBをふっとばす秘技。
`$ heroku run RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:drop`
