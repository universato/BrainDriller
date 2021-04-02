module ApplicationHelper
  def problem_count_select_list(max_problem)
    if max_problem < 10
      # a = [*(1...max_problem)].map{ |el| [el, el] }
      # a + ["#{max_problem}(全問)", max_problem]
      [10, *(1...max_problem)]
    elsif max_problem == 10
      # [[1, 1], [3, 3], [5, 5]] + ["#{max_problem}(全問)", max_problem]
      [10, 1, 3, 5, 10].map(&:to_s)
    else
      [10, 1, 3, 5, 10]
    end
  end
end
