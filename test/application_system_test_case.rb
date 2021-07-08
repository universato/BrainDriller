require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  if ENV['HEADED'] || ENV['H']
    driven_by :selenium, using: :chrome # , screen_size: [1400, 1400]
  else
    # driven_by :selenium, using: :headless_chrome
    driven_by :selenium_chrome_headless
  end
end

__END__

Run options: --seed 13949
バリデーションに失敗しました: タイトル を入力してください, タイトル は1文字以上で入力してください
