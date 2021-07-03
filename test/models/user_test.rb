require "test_helper"

class UserTest < ActiveSupport::TestCase
  def standard_user
    User.new({
      login_name: "john",
      nickname: "j",
      email: "john@example.com",
      password: "foobar"
    })
  end

  test "the truth" do
    assert users(:uni)
  end

  test "empty login_name raises error" do
    user = standard_user
    user.login_name = ""
    assert_raise(ActiveRecord::RecordInvalid){ user.save! }
  end

  test "invalid too long name" do
    user = standard_user
    user.login_name = "a" * 31
    assert_raise(ActiveRecord::RecordInvalid){ user.save! }
  end

  test "empty email raises error" do
    user = standard_user
    user.email = ""
    assert_raise(ActiveRecord::RecordInvalid){ user.save! }
  end

  test "empty password raises error" do
    user = standard_user
    user.password = ""
    assert_raise(ActiveRecord::RecordInvalid){ user.save! }
  end

  test "unique login_name" do
    user = standard_user
    user.login_name = "uni"
    assert_raise(ActiveRecord::RecordInvalid){ user.save! }
  end

  test "unique email" do
    user = standard_user
    user.email = "uni@example.com"
    assert_raise(ActiveRecord::RecordInvalid){ user.save! }
  end
end
