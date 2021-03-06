require_relative "../test_helper.rb"

class DrillTest < ActiveSupport::TestCase
  test "create drill" do
    user = users(:smith)
    drill = user.drills.build({
      title: "Our Drill",
      guide: "",
    })
    assert_difference('Drill.count', 1){ drill.save }
    assert_equal drill.user.id, user.id
    assert_equal "draft", drill.state
    assert_equal 0, drill.problems.size
    assert_equal 0, drill.problem_size
    assert_equal 0, drill.number_of_views
    assert_equal 0, drill.impressions_count
  end

  test "empty user raise error" do
    drill = Drill.new({
      user_id: nil,
      title: "Thsi is title",
      guide: "This is guide...",
    })
    assert_raises(ActiveRecord::RecordInvalid){ drill.save! }
  end

  test "empty title raises Error" do
    user = users(:smith)
    drill = user.drills.create({
      title: "",
      guide: "This is guide...",
    })
    assert_raises(ActiveRecord::RecordInvalid){ drill.save! }
  end
end
