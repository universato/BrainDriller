user = User.find_or_create_by(login_name: "uni")

Drill.create({
  user_id: user.id,
  title: "Draft without Problems",
  guide: "this is emptydraft...",
})

drill = Drill.create({
  user_id: user.id,
  title: "Draft with Problems",
  guide: "this is emptydraft...",
})

drill.problems.create({
  drill_id: drill.id,
  user_id: user.id,
  title: "Problem of Draft drill",
  statement: "Problem",
  format: "basic_choices",
  choices: ["A", "B", "C", "D"],
  correct_option: 0,
  explanation: 'this is expnalanation',
})
