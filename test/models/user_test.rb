require_relative "../test_helper.rb"

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
    assert standard_user.valid?
  end

  test "empty login_name raises error" do
    user = standard_user
    user.login_name = ""
    assert_not user.valid?
    assert_raise(ActiveRecord::RecordInvalid){ user.save! }
  end

  test "invalid too long name" do
    user = standard_user
    user.login_name = "a" * 31
    assert_not user.valid?
    assert_raise(ActiveRecord::RecordInvalid){ user.save! }
  end

  test "empty email raises error" do
    user = standard_user
    user.email = ""
    assert_not user.valid?
    assert_raise(ActiveRecord::RecordInvalid){ user.save! }
  end

  test "empty password raises error" do
    user = standard_user
    user.password = ""
    assert_not user.valid?
    assert_raise(ActiveRecord::RecordInvalid){ user.save! }
  end

  # Instagram 数値始まり、アンダースコア連続
  # フィヨルドブートキャンプ、英数字、ハイフン、(ただしハイフンの先頭・末尾の不可、ハイフン連続不可)
  # Twitter: アンダースコア(先頭・末尾OK、連続OK)
  test "unique login_name" do
    user = standard_user
    user.login_name = "uni"
    assert_not user.valid?
    assert_raise(ActiveRecord::RecordInvalid){ user.save! }

    user.login_name = "AAAA"
    assert user.valid?

    user.login_name = "uni123"
    assert user.valid?

    user.login_name = "u3333"
    assert user.valid?

    user.login_name = "UNI"
    assert_not user.valid?
    assert_raise(ActiveRecord::RecordInvalid){ user.save! }

    user.login_name = "11uni"
    assert_not user.valid?
    assert_raise(ActiveRecord::RecordInvalid){ user.save! }
  end

  test "unique login_name with underscore" do
    user = standard_user

    user.login_name = "abc_xyz"
    assert_not user.valid?
    assert_raise(ActiveRecord::RecordInvalid){ user.save! }

    user.login_name = "__abc_xyz__"
    assert_not user.valid?
    assert_raise(ActiveRecord::RecordInvalid){ user.save! }
  end

  test "unique login_name with hyphen" do
    user = standard_user

    user.login_name = "-aaaaaaaaaaaaaaaaaa"
    assert_not user.valid?
    assert_raise(ActiveRecord::RecordInvalid){ user.save! }

    user.login_name = "abcdefga-"
    assert_not user.valid?
    assert_raise(ActiveRecord::RecordInvalid){ user.save! }

    user.login_name = "abc--xyz"
    assert_not user.valid?
    assert_raise(ActiveRecord::RecordInvalid){ user.save! }

    user.login_name = "abc-xyz"
    assert_not user.valid?
    assert_raise(ActiveRecord::RecordInvalid){ user.save! }

    user.login_name = "u3333"
    assert user.valid?
  end

  test "unique email" do
    user = standard_user
    user.email = "uni@example.com"
    assert_not user.valid?
    assert_raise(ActiveRecord::RecordInvalid){ user.save! }

    user.email = "UNI@EXAMPLE.COM"
    assert_not user.valid?
    assert_raise(ActiveRecord::RecordInvalid){ user.save! }
  end
end
