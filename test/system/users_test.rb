# frozen_string_literal: true

require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  include Warden::Test::Helpers
  # For login and logout
  # login_as(users(:admin), scope: :user)
  # logout(:user)

  test "show" do
    visit "/users/#{users(:smith).id}"
  end

  test "user edit profile" do
    login_as(users(:uni), scope: :user)
    visit root_path
    click_link "アカウント", match: :first, exact: true
    click_link "設定", match: :first, exact: true
  end
end
