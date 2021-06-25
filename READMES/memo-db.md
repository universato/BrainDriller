
rails db
select * from users;

SQL文の文末に`;`をつけるの忘れがち。

PostgreSQL
`\dt`でテーブル一覧。

モデルを見る、という方法もあるな。

```sql
\q  終了
\dt テーブル一覧
```

[db/README.md](../db/README.md)
[db/README.md](db/README.md)

# DB

```rb
UserProblemResult.where(user_id: 1)
UserProblemResult.where(user_id: 1).size
UserProblemResult.where(user_id: 1).pluck(:number_of_submissions)
```

```rb
Drill.find_by(title: "Ruby").id
User.find_by(login_name: "uni").id
Drill.find_by(title: "Ruby").problems.pluck(:id, :number_of_submissions)
Drill.find_by(title: "Ruby").problems.pluck(:id, :number_of_submissions, :number_of_views)
Drill.find_by(title: "Ruby").problems.pluck(:id)
UserProblemResult.where(problem_id: [283, 181, 182, 284, 183])
```
16, 1

```rb
Problem.column_names.grep
```
