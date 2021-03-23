user = User.first

if user.nil?
  pust "ユーザーが0により終了。seeds/drills.rb line_no:#{__LINE__}"
  exit
end

puts "環境:"
puts Rails.env

drill_id = Drill.count
10.times do
  drill = user.drills.create!(
    title: "タイトル#{drill_id}だよ",
    guide: "ガイド#{drill_id}だよ",
    state: "full_open",
  )

  puts drill_id.to_s + "のドリルが作れらたはず……"

  10.times do
    drill.problems.create!(
      user: user,
      title: "問題だよ",
      statement: "問題文",
      explanation: "説明文",
      format: "basic_choices",
      choices: ["選択肢1", "選択肢2", "選択肢3", "選択肢4"],
      correct_option: 1,
    )
  end

  drill_id += 1
end

puts "aaaaaaaaaa"

drill_id = Drill.count
drill = user.drills.create!(
  title: "Ruby",
  guide: "Rubyの基本的な問題を扱っています。",
  state: "full_open",
)

puts drill_id.to_s + "のドリルが作れらたはず……"

statement = <<TEXT
## Rubyの質問

# あああああ

### いいいいいいい

- aaaaa
- bbbbb
- ccccc

```ruby
x = 5
p x
puts "Hello, World"
```

```rb
x = 5
p x
puts "Hello, World"

<h1> h111------</h1>
<br>
<hr>


```
TEXT

10.times do
  drill.problems.create!(
    user: user,
    title: "Rubyの問題",
    statement: statement ,
    explanation: "説明文",
    format: "basic_choices",
    choices: ["Hello", "World", "puts", "try"],
    correct_option: 1,
  )
end
