module ApplicationHelper
  def problem_count_select_list(max_problem)
    if max_problem < 10
      a = [*(1...max_problem)].map{ |el| [el, el] }
      a + ["#{max_problem}(全問)", max_problem]
      [10,  *(1...max_problem)]
    elsif max_problem == 10
      [[1, 1], [3, 3], [5, 5]] + ["#{max_problem}(全問)", max_problem]
      [10, 1, 3, 5, 10].map(&:to_s)
    else
      #a = [1, 2, 3, 4, 5] + 10.step(max_problem, 10).step
      # a << max_problem
      # a = [[1, 1], [3, 3], [5, 5]]
      # a.concat 10.step(max_problem - 1, 10).to_a
      # a + ["#{max_problem}(全問)", max_problem]
      a = [10, 1, 3, 5] + 10.step(max_problem, 10)
    end
  end

  require "redcarpet"
  require "coderay"

  class HTMLwithCoderay < Redcarpet::Render::HTML
      def block_code(code, language)
          language = language.split(':')[0]

          case language.to_s
          when 'rb'
              lang = 'ruby'
          when 'yml'
              lang = 'yaml'
          when 'css'
              lang = 'css'
          when 'html'
              lang = 'html'
          when ''
              lang = 'md'
          else
              lang = language
          end

          CodeRay.scan(code, lang).div
      end
  end

  def markdown(text)
      html_render = HTMLwithCoderay.new(filter_html: true, hard_wrap: true)
      options = {
          autolink: true,
          space_after_headers: true,
          no_intra_emphasis: true,
          fenced_code_blocks: true,
          tables: true,
          hard_wrap: true,
          xhtml: true,
          lax_html_blocks: true,
          strikethrough: true
      }
      markdown = Redcarpet::Markdown.new(html_render, options)
      markdown.render(text)
  end
end
