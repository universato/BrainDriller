require_relative "./test_helper.rb"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  if ENV['HEADED'] || ENV['H']
    driven_by :selenium, using: :chrome # , screen_size: [1400, 1400]
  else
    # driven_by :selenium, using: :headless_chrome
    driven_by :selenium_chrome_headless
  end
end
