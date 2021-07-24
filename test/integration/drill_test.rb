require 'test_helper'

class IntegrationDrillTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  test "Other user cannot access new " do
    logout(:user)
    get "/drills/new"
    assert_redirected_to new_user_session_path

    login_as(users(:smith), scope: :user)
    get "/drills/new"
    assert_redirected_to root_path
  end

  test "Other user cannot access drill-edit" do
    admin_drill_edit_url = "/drills/#{users(:uni).drills.last.id}/edit"

    logout(:user)
    get admin_drill_edit_url
    assert_redirected_to new_user_session_path

    login_as(users(:smith), scope: :user)
    get admin_drill_edit_url
    assert_redirected_to root_path
  end
end
