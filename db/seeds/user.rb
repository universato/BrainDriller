# 追加のユーザーをまとめて生成する
id = User.count
50.times do
  name = Faker::Name.name
  password = Faker::Internet.password(min_length: 6)

  User.create(
    login_name: name,
    nickname: name,
    email: "a#{id}@example.com",
    password: password,
    password_confirmation: password
  )

  id += 1
end

# Rails・seedファイルを分割して管理する - Qiita https://qiita.com/masaki7555/items/d65f56958020cbca5ee0
