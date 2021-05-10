# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

# [rake db:migrate した時に発行される SQL を調べる方法 \- Qiita](https://qiita.com/pekepek/items/2dc9dfc9ed2b7f3b0f0c)
task log: :environment do
  ActiveRecord::Base.logger = Logger.new($stdout)
end

# [Rails・seedファイルを分割して管理する \- Qiita](https://qiita.com/masaki7555/items/d65f56958020cbca5ee0)
# bundle exex rake db:seed:user
Pathname.glob(Rails.root.join('db/seeds/*.rb')) do |path|
  desc("Load the seed data from db/seeds/#{path.basename}")
  task("db:seed:#{path.basename('.*')}"  => :environment){ load(path) }
  task("db:seeds:#{path.basename('.*')}" => :environment){ load(path) }
end

# [Pathname.glob (Ruby リファレンスマニュアル)](https://docs.ruby-lang.org/ja/latest/method/Pathname/s/glob.html)
# [Kernel#desc (Ruby 3.0.0 リファレンスマニュアル\)](https://docs.ruby-lang.org/ja/latest/method/Kernel/i/desc.html)
# [Kernel#task (Ruby 3.0.0 リファレンスマニュアル)](https://docs.ruby-lang.org/ja/latest/method/Kernel/i/task.html)
# [Kernel.task - Rake](https://ruby.github.io/rake/Rake/DSL.html#method-i-task)
# [Kernel.desc - Rake](https://ruby.github.io/rake/Rake/DSL.html#method-i-desc)
