def create_user(name, admin: false)
  User.create(
    login_name: name,
    nickname: name,
    email: "#{name}@example.com",
    admin: admin,
    password: "foobar",
    password_confirmation: "foobar",
    confirmed_at: Time.current,
  )
  # 何度も実行されることを想定すると、メアドでエラーが起きるかもしれないので、エラーはださない。
end

create_user("uni", admin: true)
create_user("ruby")

puts "2ユーザーの作成で打ち切って、次にいきます l.#{__LINE__}"

__END__

return if User.count > 100

# 追加のユーザーをまとめて生成する
id = User.count
50.times do
  name = Faker::Name.name
  # password = Faker::Internet.password(min_length: 6)
  password = "foobar"

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
