module ApplicationHelper
  def problem_count_select_list(max_problem)
    default_options = [["#{max_problem}(全問)", max_problem]]
    default_options.unshift([10, 10]) if max_problem > 10
    if max_problem < 10
      default_options + [*(1...max_problem)]
    else
      options = ([1, 3, 5] + 10.step(max_problem, (max_problem / 10).ceil(-1)).to_a).map{ |e| [e, e] }
      default_options + options
    end
  end

  def percent(numerator, denominator)
     r = numerator.to_f / denominator.to_f
     r.nan? ? "- %" : sprintf("%5.1f", r) + "%"
  end
end
