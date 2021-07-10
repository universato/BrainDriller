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
end
