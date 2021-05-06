# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
module Seed
  def self.run_seed(path)
    if require_relative(path)
      puts "実行された: " + path
    else
      puts "実行されず: " + path
    end
  end
end

Seed.run_seed("./seeds/user")
Seed.run_seed("./seeds/cpa_csv")
Seed.run_seed("./seeds/simple_problems")
Seed.run_seed("./seeds/problems")
# Seed.run_seed("./seeds/drills")
