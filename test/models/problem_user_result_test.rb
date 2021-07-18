require_relative "../test_helper.rb"

class ProblemUserResultTest < ActiveSupport::TestCase
  test "index" do
    ProblemUserResult.create!(user: users(:uni), problem: problems(:ruby1))
    ProblemUserResult.create!(user: users(:uni), problem: problems(:ruby2))
  end
end
