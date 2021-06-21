# frozen_string_literal: true

require 'application_system_test_case'

class SignUpTest < ApplicationSystemTestCase
  test "sign_up" do
    visit '/users/sign_up'
    within 'form[id=new_user]' do
      fill_in "user[login_name]", with: "new"
      fill_in "user[email]", with: "new@example.com"
      fill_in "user[password]", with: "foobar"
      fill_in "user[password_confirmation]", with: "foobar"
    end
    click_button "登録する"
  end

  test "sign_in" do
    visit '/users/sign_in'
    within 'form[id=new_user]' do
      fill_in "user[email]", with: "uni@example.com"
      fill_in "user[password]", with: "foobar"
    end
    click_button "ログインする"
  end
end
