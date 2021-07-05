# frozen_string_literal: true

require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  include Warden::Test::Helpers
  def setup
  end

  def login_as_admin
    login_as(users(:admin), scope: :user)
  end

  def login_as_basic_member
    login_as(users(:smith), scope: :user)
  end

  test 'aaa' do
    login_as_admin
  end
end
