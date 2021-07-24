require_relative '../../test_helper.rb'

class Admin::DrillsTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  test 'GET /admin/users by normal user' do
    login_as(users(:smith), scope: :user)

    get '/admin/users'
    assert_redirected_to root_url

    get "/admin/users/#{users(:smith).id}"
    assert_redirected_to root_url

    get "/admin/users/#{users(:smith).login_name}"
    assert_redirected_to root_url
  end

  test 'GET /admin/users by logout user' do
    logout(:user)

    get '/admin/users'
    assert_redirected_to root_url

    get "/admin/users/#{users(:smith).id}"
    assert_redirected_to root_url

    get "/admin/users/#{users(:smith).login_name}"
    assert_redirected_to root_url
  end

  test 'GET /admin/users by admin' do
    login_as(users(:admin), scope: :user)

    get '/admin/users'
    assert_response :success

    get "/admin/users/#{users(:smith).id}"
    assert_response :success

    get "/admin/users/#{users(:smith).login_name}"
    assert_response :success
  end
end
