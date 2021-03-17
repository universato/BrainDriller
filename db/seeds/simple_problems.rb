File.open('db/simple_problems/english.txt') do |file|
  title =  file.gets

  flag = 0
  options = {}
  while line = file.gets
    if line == "\n"
      Problem.create(**options) if options.size > 0
      options = {title: title, user_id: 1, problem_type: :basic_choices, explanation: '', }
      flag = 0
    else
      case flag
      in 0
        options[:statement] = line
      in 1
        options[:choices] = [line.chomp]
      in 2..4
        options[:choices] << line.chomp
      in 5
        options[:correct_option] = line.to_i - 1
      else
        options[:explanation] = line.chomp || ''
      end
      flag += 1
    end

  end
end

puts title
