# frozen_string_literal: true

require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  include Warden::Test::Helpers
  def setup
  end

  def login_as_admin
    encrypted_password = "$2a$12$jLX1cpGn1PvdwK2UoxkUQ.VpjaHV.1f2HcMyC9EQAWvP/6MDYhQ0m" # "foobar"
    user = User.find_by(
      login_name: "admin",
      email: "admin@example.com",
      encrypted_password: encrypted_password,
    )
    user = users(:admin)
    login_as(user, scope: :user)
  end

  def login_as_basic_member
    encrypted_password = "$2a$12$jLX1cpGn1PvdwK2UoxkUQ.VpjaHV.1f2HcMyC9EQAWvP/6MDYhQ0m" # "foobar"
    user = User.find_by(
      login_name: "smith",
      email: "smith@example.com",
      encrypted_password: encrypted_password,
    )
    login_as(user, scope: :user)
  end

  test 'aaa' do
    login_as_admin
  end
end
