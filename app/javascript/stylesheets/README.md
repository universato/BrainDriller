# CSSメモ

# bootcamp

auth-formtというブロック。
それに、headerやbody, titleのelementがある。

必須の入力項目に`is-required`がある。


登録情報変更のフォーム
.auth-form.is-sign-up.a-card.is-in-app
  .auth-form__header
    .auth-form__title
  .auth-form__body
    form#ayment-form
      .form-items
        .form-item
          label.a-label.is-required
          input.a-text-input
          .a-form-help
        .form-item
          label.a-label
          form-item__mention-input
            input.a-text-input
      .form-items
        h3.form__items-title
        .form-item
          .form-item__button
            .a-button is-md is-secondary
      .form-actions
        ul.form-actions__items
          li.form-actions__item is-main
            input.a-button is-lg is-warning is-block

a-text-input
form-item

`auth-form`ブロックに、`header`, `body`, `footer`のようなelementがある。

`__items`エレメント
`__item`エレメント
`__link`エレメント

.container
  .auth-form-logo
    .auth-form-logo__link
  .auth-form
    .auth-form__header
      .auth-form__title
    .auth-form__body
      form
    .auth-form__footer
      nav.auth-form-nav
        ul.auth-form-nav__items
          li.auth-form-nav__item
            a.auth-form-nav__link

ログイン 入力欄 幅いっぱい
デフォルトの.fieldから.form-itemに変更する。
.form-itemクラスを付与して、scssも読み込むようにする。
.form-itemだけにwidth:100%;をつけても広がらなかった。
.form-itemではなく、inputの方にwidth:100%;をつけるだけで良かったみたい。
しかし、幅が広くなりすぎた。

[![Image from Gyazo](https://i.gyazo.com/83153e93bc3a0d7fdbae2fc014bc2f32.png)](https://gyazo.com/83153e93bc3a0d7fdbae2fc014bc2f32)

```erb
 <%= form_for(resource, as: resource_name, url: session_path(resource_name), html: { class: "form-panel" } ) do |f| %>
```

効かない。まず、クラスが変わってない。
自分が思っているより下の階層に効いていた。凡ミス。



```css
.form-panel {
  margin: 0 auto;
  max-width: 560px;
}
```

ボタンがいけてない。


リンク

あっちをたてるとこっちがたたず。
