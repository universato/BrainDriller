# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

module Seed
  def self.run_seed(path)
    s = Time.current
    output = require_relative(path) ? "実行された: " : "実行されず: "
    puts output + path + " ,time: #{Time.current - s} s"
  end
end

Seed.run_seed("./seeds/user")

Seed.run_seed("./seeds/ruby_drill")
Seed.run_seed("./seeds/china_word")

Seed.run_seed("./seeds/update_problem_size")

if Rails.env.development?
  Seed.run_seed("./seeds/open_drills")
end

# 2021/7/4
# $ time rails db:reset
# rails db:reset  5.81s user 1.38s system 46% cpu 15.423 total
# rails db:reset  4.14s user 1.38s system 46% cpu 15.423 total
