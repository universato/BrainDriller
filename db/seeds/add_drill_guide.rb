uni = User.find_by!(login_name: "uni")

ruby_guide = <<~MD
Rubyの基本の問題を集めました。
Rubyを解いてみるといいです。
MD

crystal_guide = <<~MD
Rubyとよく似たCrystalですが、Rubyと違う点を集めてみました。
よかったら解いてみてください。
MD

javascript_guide = <<~MD
JavaScriptの基本的な問題です。
どんどん解いてJSを得意になりましょう。
MD

css_guide = <<~MD
CSSの基本的な問題です。
解いてみましょう。
MD

drill = Drill.find_by!(user: uni, title: "Ruby")
drill.update(guide: ruby_guide)

drill = Drill.find_by!(user: uni, title: "Crystal")
drill.update(guide: crystal_guide)

drill = Drill.find_by!(user: uni, title: "JavaScript")
drill.update(guide: javascript_guide)

drill = Drill.find_by!(user: uni, title: "CSS")
drill.update(guide: css_guide)
