# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

# [rake db:migrate した時に発行される SQL を調べる方法 \- Qiita](https://qiita.com/pekepek/items/2dc9dfc9ed2b7f3b0f0c)
task log: :environment do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end
