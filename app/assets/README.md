`heroku logs`
```
ActionView::Template::Error (The asset "default_icon" is not present in the asset pipeline.):
```

`config/environments/production.rb`の次の部分の`false`を`true`に変更した。
```rb
  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = true
```

[Rails：Asset PipelineとPreCompile \- tyoshikawa1106のブログ](https://tyoshikawa1106.hatenablog.com/entry/2015/09/02/142446)
> この「config.assets.compile」ですが、動的にPreCompileをしてくれるオプションとのことで、Herokuなどの本番環境で動かすときは、「false」にして自分でPreCompileする方がいいみたいです。
PreCompileは次のコマンドで実行できます。
$ rake assets:precompile
