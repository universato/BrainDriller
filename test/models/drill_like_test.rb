require_relative "../test_helper.rb"

class DrillLikeTest < ActiveSupport::TestCase
  test "unique" do
    ruby_drill = drills(:ruby)
    user = users(:smith)

    drill_likes = DrillLike.create!(user: user, drill: ruby_drill)
    assert_raises(ActiveRecord::RecordInvalid){ DrillLike.create!(user: user, drill: ruby_drill) }

    drill_likes.destroy
    DrillLike.create!(user: user, drill: ruby_drill)
    drill_likes.destroy
  end

  test "multiple" do
    ruby_drill = drills(:ruby)
    crystal_drill = drills(:'crystal-lang')

    adam = users(:adam)
    bob = users(:bob)
    smith = users(:smith)

    DrillLike.create!(user: adam, drill: ruby_drill)
    DrillLike.create!(user: bob, drill: ruby_drill)
    DrillLike.create!(user: smith, drill: ruby_drill)
    DrillLike.create!(user: adam, drill: crystal_drill)
    DrillLike.create!(user: bob, drill: crystal_drill)
    DrillLike.create!(user: smith, drill: crystal_drill)

    assert_equal 2, DrillLike.where(user: bob).size
    assert_equal 3, DrillLike.where(drill: ruby_drill).size

    drill_like = DrillLike.find_by(user: bob, drill: ruby_drill)
    drill_like.destroy!
    assert_equal 1, DrillLike.where(user: bob).size
    assert_equal 2, DrillLike.where(drill: ruby_drill).size
  end
end
