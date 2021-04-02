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
