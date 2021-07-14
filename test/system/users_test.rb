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

  test "user change password" do
    login_as(users(:uni), scope: :user)
    visit root_path
    click_link "アカウント", match: :first, exact: true
    click_link "設定", match: :first, exact: true
    within 'form[id=edit_user]' do
      fill_in "user[password]", with: "barbar"
      fill_in "user[password_confirmation]", with: "barbar"
      fill_in "user[current_password]", with: "foobar"
    end
    click_button "更新する"

    assert_text "アカウント情報を変更しました"

    click_link "アカウント", match: :first, exact: true
    click_link "設定", match: :first, exact: true
    within 'form[id=edit_user]' do
      fill_in "user[password]", with: "foobar"
      fill_in "user[password_confirmation]", with: "foobar"
      fill_in "user[current_password]", with: "barbar"
    end
    click_button "更新する"
  end
end
