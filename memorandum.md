# メモ

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

### CSS

`border-color: #fff`とやっても、線が表示されない。
線の情報は下の子タグに継承されていってる。
基本のベースが、`border-style: none;`だったりするため、単に線の色情報を付加しても、線は表示されない。

継承のケースでクラスをソートするために`type`は予約されているから、エラーが起こされるらしい。

ドリル
- 全問を解く
- ランダムに解く
- 解けてない問題をランダムに解く

ドリル(この時点でドリルIDがわかっている)
→ クリック時点で、ドリルIDを渡す必要あり。(DB側はドリルIDさえわかっていれば取れる)
→ クリック時点で、「問題の解き方」の情報を持たせるか、

→ GETで指定された「問題ID」「問題の解き方」によって、問題の選定・順番などを考慮して渡す。(ゆくゆくはログイン情報から解ける問題・解けない問題を選定したい。)

→ 画面遷移が必要？

3/19

Fjord


3/21

```
Uncaught TypeError: Cannot read property '1' of undefined
    at Proxy.nextProblem (solving.vue:88)
    at Object.onClick._cache.<computed>._cache.<computed> (solving.vue:26)
    at callWithErrorHandling (runtime-core.esm-bundler.js:225)
    at callWithAsyncErrorHandling (runtime-core.esm-bundler.js:235)
    at HTMLButtonElement.invoker (runtime-dom.esm-bundler.js:372)
```
↓スペルミスかな
```js
this.currentProblem = this.probkems[this.currentProblemIndex];
```

最小再現
```js
a = undefined
a[1]
```

```js
a = null
a[1]
```

```
/workspace/Main.js:2
a[1]
 ^

TypeError: Cannot read property '1' of null
```


# やいまクイズ

[やいまクイズ](https://yaima-quiz.kanasann.com/)

選択肢

各問題に、correct,uncorrect1,uncorrect2のプロパティがある。
シャッフルした問題というdata枠を用意して、そこにいれる。
URLによって、取り出すスタイル。これ真似するか。

`resources/js/components`

```js
  methods: {
    getQuizzes: function() {
      let quizUrl = location.pathname;
      let catId = quizUrl.match(/\d/g);
      let catNum;
      if (catId) {
        catNum = catId.join("");
      }
      if (quizUrl == "/quiz/" + catNum) {
        this.axiosUrl = "ajax/menu" + catNum;
      } else if (quizUrl == "/quiz/region/" + catNum) {
        this.axiosUrl = "ajax/region" + catNum;
      } else {
        this.axiosUrl = "ajax/menu";
      }
```

この`match(/\d/g)`はpathnameの文字列にある数字を拾った1文字の配列`catId`を作って、joinで結合させてるらしい。やばい。

`location.pathname`は、

# bootstrap

クラスの1つ1つの細かいところで、色付けだけのクラスだったり、右寄せや中央寄せだけのクラスがあったりするのやばいな。

`bg-primary`
`text-center`, `text-right`
`w-25`, `w-75`
`h-100`, `h-50`

`[p|m][location]-[size]`
location
- t, b, l, r
- x, y

size
- 0
- 1 0.25rem
- 2 0.5rem
- 3 1.0rem
- 4 1.5rem
- 5 3.0rem
- auto
`pt-3` padding-top-1rem

!importantがついているので、注意。

`btn-primary`
`btn-lg` `btn-sm`

|略  |      |
|:---|:---  |
|t   |top   |
|b   |button|
|l   |left  |
|r   |right |
|w   |width |
|h   |height|

|略  |       |
|:---|:---   |
|btn |button |
|p   |padding|
|m   |margin |

|略  |       |
|:---|:---   |
|bg  |background|

|略  |       |
|:---|:---  |
|sm  |small |
|md  |medium|
|lg  |large |
|xl  |extra large|

row
col-8
col-4

row
col-6
col-6

|略  |       |
|:---|:---  |
|sm  |576- |
|md  |medium|
|lg  |large |
|xl  |extra large|

```js

```
[![Image from Gyazo](https://i.gyazo.com/e73971543a9c84dfcd1464dd25218bc8.png)](https://gyazo.com/e73971543a9c84dfcd1464dd25218bc8)

`d-flex`の下の方にあるタグ、日本語だと文字が下方向に行く感じがある。
`white-space: no-wrap;`をCSSで加えると、大丈夫。

[Vue\.js \+ marked\.js \+ highlight\.jsを使ってシンタックスハイライト機能付きマークダウンエディタを作ってみたのでMEMO \- Madogiwa Blog](https://madogiwa0124.hatenablog.com/entry/2019/01/03/203334)

```js
import hljs from 'highlight.js';
```
`.`が必要なのでは。

Twitter 15文字
はてな 32文字

[devise使用時、usersにimageカラムを追加して画像を表示 \- Qiita](https://qiita.com/shlia/items/d4fdd952b38d4140062d)

* Imageではなく、Iconで進めていく。

`rails g migration AddIconToUsers icon:string`
`rails db:migrate`

```rb
gem 'carrierwave'
gem 'mini_magick'
```
`bundle install`


```rb
class User < ApplicationRecord
  mount_uploader :icon, IconUploader
end
```

# プロフィール

プロフィールの変更は、
- プロフィールの変更
- パスワードの変更
- アカウント削除
をきっちりわける。URLも別のにした方がいいかもしれない。

```
Started PUT "/users" for ::1 at 2021-03-24 15:17:45 +0900
Processing by Devise::RegistrationsController#update as HTML
  Parameters: {"authenticity_token"=>"[FILTERED]", "user"=>{"icon"=>#<ActionDispatch::Http::UploadedFile:0x00007fb18f127df0 @tempfile=#<Tempfile:/var/folders/2v/8_ymh7552ng507sfsyp23gq40000gn/T/RackMultipart20210324-33231-kvw552.jpeg>, @original_filename="freeicon11_by_kuroi.jpeg", @content_type="image/jpeg", @headers="Content-Disposition: form-data; name=\"user[icon]\"; filename=\"freeicon11_by_kuroi.jpeg\"\r\nContent-Type: image/jpeg\r\n">, "email"=>"uni@example.com", "current_password"=>"[FILTERED]"}, "commit"=>"更新"}
  User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."id" = ? ORDER BY "users"."id" ASC LIMIT ?  [["id", 1], ["LIMIT", 1]]
  User Load (0.1ms)  SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
Unpermitted parameter: :icon
Unpermitted parameter: :icon
Unpermitted parameter: :icon
Unpermitted parameter: :icon
Redirected to http://localhost:3000/
Completed 302 Found in 411ms (ActiveRecord: 0.4ms | Allocations: 4690)
```

`Unpermitted parameter: :icon`

```
[Vue warn]: Component is missing template or render function.
  at <App>
```
何も見れなくなって、このエラー。シンタックスエラーに近かった。


```rb
  def after_update_path_for(resource)
    "/users/#{resource.id}"
  end
```
`/users/#{resource.id}`
先頭に/がないとエラーになってしまう。

```
Redirected to http://localhost:3000users/1
```

エラー
```
POST http://localhost:3000/api/drills/grade 404
```

```rb
  namespace :api do
    resources :drills, only: %i(index show new create edit)
    post 'drills/grade', to: "drills#grade"
  end
```

う〜ん、Railsのバージョンを上げた際に、以下のエラーがでた記憶。

```
$ rails t
~/rails/BrainDriller/vendor/bundle/ruby/3.0.0/gems/bootsnap-1.7.2/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:34:in `require': cannot load such file -- rexml/document (LoadError)
```

LoadError - cannot load such file -- rexml/document #10388

[CocoaPods/CocoaPodsのIssue #10388](https://github.com/CocoaPods/CocoaPods/issues/10388)

2ヶ月前
[Rails 6\.1, Ruby 3\.0\.0: tests error as they cannot load rexml \- Stack Overflow](https://stackoverflow.com/questions/65479863/rails-6-1-ruby-3-0-0-tests-error-as-they-cannot-load-rexml)

`gem 'rexml'`をGemfileに書いてみた。
`gem`コマンドでドキュメントをインストールしないようにしたのが原因だったりするのかな。


# シンタックスハイライト

[コードのハイライト表示 JS ライブラリ ３種 \- Qiita](https://qiita.com/tadnakam/items/1323d03743fc0101aa50)


markdown
YAML front matter

- front_matter_paser
  - [Github](https://github.com/waiting-for-dev/front_matter_parser)
  - [rubygems](https://rubygems.org/gems/front_matter_parser)

#

[JavaScriptでブラウザバックを "ほぼ完全禁止" する方法 \| PisukeCode \- Web開発まとめ](https://pisuke-code.com/javascript-prohibit-browser-back/)

```js
history.pushState(null, null, location.href);
window.addEventListener('popstate', (e) => {
  history.go(1);
});
```

[\+JavaScript\+ブラウザの戻るボタンの無効化 \- Free Flying](http://tuotehhou.y.ribbon.to/index.php?%2BJavaScript%2B%E3%83%96%E3%83%A9%E3%82%A6%E3%82%B6%E3%81%AE%E6%88%BB%E3%82%8B%E3%83%9C%E3%82%BF%E3%83%B3%E3%81%AE%E7%84%A1%E5%8A%B9%E5%8C%96)

```js
function redirect(url)
{
    var Backlen=history.length;
    history.go(-Backlen);
    window.location.replace(url);
}
```
これ上手く行かない。なんか戻り続ける感じ。危険な感じする。

```rb
history.forward();
```
無反応、よくわからない。

[JavaScriptだけでブラウザの「戻る」ボタンを無効化する方法 \- HIDARI日記（右）](https://hidari-lab.hatenablog.com/entry/2015/03/02/212818)


CSS版のRuboCopみたいなの。
[CSScomb](https://github.com/csscomb)
[A mighty, modern style linter · stylelint](https://stylelint.io/)


[marked\.jsでXSS対策の設定をする \- Qiita](https://qiita.com/hyakuson/items/cb204f84f854e9efc482)
```js
marked.setOptions({
  sanitize: true,
});
```

[MarkdownをHTMLに変換する · JavaScript Primer \#jsprimer](https://jsprimer.net/use-case/nodecli/md-to-html/)
```
```

[marked\.jsを使ってリアルタイムにマークダウン変換したら、改行が反映されなかった \- Qiita](https://qiita.com/rf_p/items/16b5e3b9bf77584690ae)


```
marked.js:373 marked(): sanitize and sanitizer parameters are deprecated since version 0.7.0, should not be used and will be removed in the future. Read more here: https://marked.js.org/#/USING_ADVANCED.md#options
```

HTMLの`hljs`クラスに、背景色がつく。


[【Railsエラー】vender/bundleにgemが入ってしまう時の解決方法｜TechTechMedia](https://techtechmedia.com/vender-bundle-solution/)

`.bundle/config`の次の行を削除
```
BUNDLE_PATH: "vendor/bundle"
```

##

```sh
$ heroku login
zsh: command not found: heroku
```

https://devcenter.heroku.com/articles/heroku-cli#download-and-install
`$ brew tap heroku/brew && brew install heroku`


```
==> Caveats
==> heroku-node
heroku-node is keg-only, which means it was not symlinked into /usr/local,
because heroku-node is only used by Heroku CLI (heroku/brew/heroku), which explicitly requires from Cellar.

If you need to have heroku-node first in your PATH, run:
  echo 'export PATH="/usr/local/opt/heroku-node/bin:$PATH"' >> ~/.zshrc

==> heroku
To use the Heroku CLI's autocomplete --
  Via homebrew's shell completion:
    1) Follow homebrew's install instructions https://docs.brew.sh/Shell-Completion
        NOTE: For zsh, as the instructions mention, be sure compinit is autoloaded
              and called, either explicitly or via a framework like oh-my-zsh.
    2) Then run
      $ heroku autocomplete --refresh-cache
  OR
  Use our standalone setup:
    1) Run and follow the install steps:
      $ heroku autocomplete

zsh completions have been installed to:
  /usr/local/share/zsh/site-functions

~/rails/BrainDriller
$ heroku -v                                                                                 !+[main]
 ›   Warning: Our terms of service have changed: https://dashboard.heroku.com/terms-of-service
heroku/7.51.0 darwin-x64 node-v12.21.0
```

```
$ heroku autocomplete                                                                       !+[main]
Building the autocomplete cache... ?
heroku: Press any key to open up the browser to login or q to exit: Building the autocomplete cache..

Opening browser to https://cli-auth.heroku.com/auth/cli/browser/111111111111111111111111111111111111?requestor=222222222222222222222222222222222222222222222222222222222222222222222222222222222
Logging in... done

Setup Instructions for HEROKU CLI Autocomplete ---

1) Add the autocomplete env var to your zsh profile and source it
$ printf "$(heroku autocomplete:script zsh)" >> ~/.zshrc; source ~/.zshrc

NOTE: After sourcing, you can run `$ compaudit -D` to ensure no permissions conflicts are present

2) Test it out, e.g.:
$ heroku <TAB>                 # Command completion
$ heroku apps:info --<TAB>     # Flag completion
$ heroku apps:info --app=<TAB> # Flag option completion

Visit the autocomplete Dev Center doc at https://devcenter.heroku.com/articles/heroku-cli-autocomplete

Enjoy!
```

```
$ heroku logs

2021-04-02T09:48:59.000000+00:00 app[api]: Build failed -- check your build output: https://dashboard.heroku.com/apps/786f7dcf-5eed-424f-aa45-3fc9b9111900/activity/builds/446de9a5-fc22-4392-b710-79998b86c7cf
```


```
$ git push heroku main                                                                        [main]
Enumerating objects: 8979, done.
Counting objects: 100% (8979/8979), done.
Delta compression using up to 8 threads
Compressing objects: 100% (7469/7469), done.
Writing objects: 100% (8979/8979), 31.81 MiB | 71.00 KiB/s, done.
Total 8979 (delta 1255), reused 8315 (delta 956), pack-reused 0
remote: Compressing source files... done.
remote: Building source:
remote:
remote: -----> Building on the Heroku-20 stack
remote: -----> Determining which buildpack to use for this app
remote:  !     Warning: Multiple default buildpacks reported the ability to handle this app. The first buildpack in the list below will be used.
remote:                         Detected buildpacks: Ruby,Node.js
remote:                         See https://devcenter.heroku.com/articles/buildpacks#buildpack-detect-order
remote: -----> Ruby app detected
remote: -----> Installing bundler 2.2.11
remote: -----> Removing BUNDLED WITH version in the Gemfile.lock
remote: -----> Compiling Ruby/Rails
remote: -----> Using Ruby version: ruby-3.0.0
remote: -----> Installing dependencies using bundler 2.2.11
remote:        Running: BUNDLE_WITHOUT='development:test' BUNDLE_PATH=vendor/bundle BUNDLE_BIN=vendor/bundle/bin BUNDLE_DEPLOYMENT=1 bundle install -j4
remote:        Your bundle only supports platforms ["x86_64-darwin-19"] but your local platform
remote:        is x86_64-linux. Add the current platform to the lockfile with `bundle lock
remote:        --add-platform x86_64-linux` and try again.
remote:        Bundler Output: Your bundle only supports platforms ["x86_64-darwin-19"] but your local platform
remote:        is x86_64-linux. Add the current platform to the lockfile with `bundle lock
remote:        --add-platform x86_64-linux` and try again.
remote:
remote:  !
remote:  !     Failed to install gems via Bundler.
remote:  !
remote:  !     Push rejected, failed to compile Ruby app.
remote:
remote:  !     Push failed
remote: Verifying deploy...
remote:
remote: !       Push rejected to brain-driller.
remote:
To https://git.heroku.com/brain-driller.git
 ! [remote rejected] main -> main (pre-receive hook declined)
error: failed to push some refs to 'https://git.heroku.com/brain-driller.git'
```

`$ bundle lock　--add-platform x86_64-linux`

`Gemfile.lock`に`x86_64-linux`が追加される。
```
PLATFORMS
  x86_64-darwin-19
  x86_64-linux
```

matchda.rbに参加した。


```
remote:        Error: vue-loader requires @vue/compiler-sfc to be present in the dependency tree.
remote:            at Object.<anonymous> (/tmp/build_3890d96b/node_modules/vue-loader/dist/index.js:8
```


```json
{
  "name": "brain-driller",
  "private": true,
  "dependencies": {
    "@fortawesome/fontawesome-free": "^5.15.2",
    "@popperjs/core": "^2.9.1",
    "@rails/actioncable": "^6.0.0",
    "@rails/activestorage": "^6.0.0",
    "@rails/ujs": "^6.0.0",
    "@rails/webpacker": "5.2.1",
    "bootstrap": "^5.0.0-beta2",
    "highlight.js": "^10.7.1",
    "highlightjs": "^9.16.2",
    "jquery": "^3.6.0",
    "lodash": "^4.17.21",
    "marked": "^2.0.1",
    "popper.js": "^1.16.1",
    "turbolinks": "^5.2.0",
    "vue": "^3.0.7",
    "vue-loader": "16.0.0-rc.0",
    "vue-template-compiler": "^2.6.12",
    "@vue/compiler-sfc": "^3.0.11",
    "vuex": "^3.6.2"
  },
  "version": "0.1.0",
  "devDependencies": {
    "webpack-dev-server": "^3.11.2"
  }
}

```

`"@vue/compiler-sfc": "^3.0.11",`が`"devDependencies"`にあって、どうも開発環境のみにあったみたいなので、場所を変更した。


マイグレーションファイルの順番でエラーになった。
順番を変更して、難を逃れた。



heroku

本番DBをふっとばす秘技。
`$ heroku run RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:drop`
↓
`Database 'daohau66v8a2bh' does not exist`


[![Image from Gyazo](https://i.gyazo.com/58f87c9fd8a2605153004e4c92535023.png)](https://gyazo.com/58f87c9fd8a2605153004e4c92535023)

タイトル表示を、タイトルだけのときは太文字で黒くして、タイトルと本文ときのときは逆に薄くするのありな気がした。いや、複雑すぎるか。
タイトルは、管理用。

問題の選択肢は、ない方がいい気がする。悩む。
問題の選択肢を書きたい人にとっては、ない方がいいだろうし、
問題の選択肢にナンバリング等があって欲しいけど書きたくない人は、自動的に書いて欲しいと思われる。
ナンバリングの種類について、「1, 2, 3, 4」「ア、イ、ウ、エ」「a, b, c, d」「A, B, C, D」「Ⅰ, Ⅱ, Ⅲ」
こういうので、悩むのはもったいないから、自分のケースだけで考えよう。


## heroku

PG

```sh
rake aborted!
ActiveModel::UnknownAttributeError: unknown attribute 'in_order' for Problem.
```


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

5/4 user#showのview作り直す。
問題を解いてるときのロゴをクリックできるようにした。

#

```ruby
def update
  @drill = Drill.find(params[:id])
  @drill.update(drill_params)
  redirect_to "/drills/#{params[:id]}"
end
```

なぜか別の画面にいけない。
`redirect_to`は文字列の最初に`/`が必要。

#

`simple_format(h(text))`

これで改行だけはいけるみたい。

#

`a`タグで`reboot.scss`で「青色と下線」がつくのが結構鬱陶しいような。
でも、装飾がなかったらなかったで、`a`タグであることを見逃してしまうかもしれない。

# footer

bootstrap `fixed-bottom`だと、常に表示されるぽくてダメ。


[HTML \- Footerを画面の１番下に配置したいが固定したくない｜teratail](https://teratail.com/questions/133065)

# ユーザー

開発環境

`@example.com`
`foobar`

#

$ rails g migration AddAdminToUsers

```rb
class AddAdminToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :admin, :boolean, default: false
  end
end
```

```rb
add_column :users, :admin, :boolean, default: false
```

#

```rb
User.pluck(:email)
```

# rouge

2017
[RailsでMarkdownを読み書きする方法 \| 人と情報](https://www.tmp1024.com/articles/rails-use-markdown-of-redcarpet)
 
2021年4月5日 21:54更新
[【Rails】Markdownで記事を書く！『redcarpet＋rouge』の導入・使い方を解説【シンタックスハイラ \- AUTOVICE](https://www.autovice.jp/articles/40)

`_rouge.scss.erb`
```erb
<%= Rouge::Themes::Base16.render(:scope => '.highlight') %>
```


を読み込むべきファイル。

`assets/stylesheetsapplication.scss`
```scss
@import 'rouge';
```

Failed to compile.

./app/javascript/stylesheets/application.scss (./node_modules/css-loader/dist/cjs.js??ref--3-1!./node_modules/postcss-loader/src??ref--3-2!./node_modules/sass-loader/dist/cjs.js??ref--3-3!./app/javascript/stylesheets/application.scss)
Module build failed (from ./node_modules/sass-loader/dist/cjs.js):
SassError: Can't find stylesheet to import.
  ╷
4 │ @import 'rouge';
  │         ^^^^^^^
  ╵
  app/javascript/stylesheets/application.scss 4:9  root stylesheet


# marked復習

https://madogiwa0124.hatenablog.com/entry/2019/01/03/203334

https://marked.js.org/#installation
`$ npm install -g marked`
`$ npm install marked`

`$ npm install marked --save`だとこうだが、yarnを使うなら下記のコマンドかな。  
`$ yarn add marked`
```json
{
  "dependencies": {
    "marked": "^2.0.7",
  },
}
```
`"marked"`が追加された。

https://marked.js.org/#installation


https://railsguides.jp/webpacker.html
- `rails new myapp --webpack=<フレームワーク名>`のような方法で作成するか、
- `rails webpacker:install:<フレームワーク名>`のように個別のコマンドラインタスクで作成する

`bin/rails webpacker:install:vue`
