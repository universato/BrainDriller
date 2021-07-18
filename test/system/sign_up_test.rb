# frozen_string_literal: true

require 'application_system_test_case'

class SignUpTest < ApplicationSystemTestCase
  include Warden::Test::Helpers # for login_as and logout
  test "sign_up" do
    logout(:user)
    visit '/users/sign_up'
    within 'form[id=new_user]' do
      fill_in "user[login_name]", with: "new"
      fill_in "user[email]", with: "new@example.com"
      fill_in "user[password]", with: "foobar"
      fill_in "user[password_confirmation]", with: "foobar"
    end
    skip if ENV['CI']
    click_button "登録する"
  end

  test "sign_in and sign_out" do
    logout(:user)
    visit '/'
    assert_text "ログイン"
    click_on "ログイン"
    # visit '/users/sign_in'
    within 'form[id=new_user]' do
      fill_in "user[email]", with: "uni@example.com"
      fill_in "user[password]", with: "foobar"
    end
    click_button "ログインする"
    assert_text "ログインしました"

    click_on "アカウント"
    click_on "ログアウト"

    assert_text "ログアウトしました"
    assert_text "ログイン"
  end
end
