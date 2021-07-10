require_relative "../test_helper.rb"

module ApplicationHelper
  class UserHelperTest < ActionView::TestCase
    test "problems_count_select_list" do
      assert_equal [["4(全問)", 4], 1, 2, 3], problem_count_select_list(4)
      assert_equal [["5(全問)", 5], 1, 2, 3, 4], problem_count_select_list(5)
      assert_equal [["10(全問)", 10], [1, 1], [3, 3], [5, 5], [10, 10]], problem_count_select_list(10)
      assert_equal [[10, 10], ["11(全問)", 11], [1, 1], [3, 3], [5, 5], [10, 10]], problem_count_select_list(11)
      assert_equal [[10, 10], ["15(全問)", 15], [1, 1], [3, 3], [5, 5], [10, 10]], problem_count_select_list(15)
      assert_equal [[10, 10], ["20(全問)", 20], [1, 1], [3, 3], [5, 5], [10, 10], [20, 20]], problem_count_select_list(20)
      assert_equal [[10, 10], ["23(全問)", 23], [1, 1], [3, 3], [5, 5], [10, 10], [20, 20]], problem_count_select_list(23)
    end
  end
end
