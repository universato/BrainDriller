# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

# [rake db:migrate した時に発行される SQL を調べる方法 - Qiita](https://qiita.com/pekepek/items/2dc9dfc9ed2b7f3b0f0c)
task log: :environment do
  ActiveRecord::Base.logger = Logger.new($stdout)
end

# [Rails・seedファイルを分割して管理する - Qiita](https://qiita.com/masaki7555/items/d65f56958020cbca5ee0)
# bundle exex rake db:seed:user
Pathname.glob(Rails.root.join('db/seeds/*.rb')) do |path|
  desc("Load the seed data from db/seeds/#{path.basename}")
  task("db:seed:#{path.basename('.*')}"  => :environment){ load(path) }
  task("db:seeds:#{path.basename('.*')}" => :environment){ load(path) }
end

# Rails.root #=> #<Pathname:/path/to/RailsApp>
# Rails.root.join('db/seeds/*.rb') #=> #<Pathname:/path/to/RailsApp/db/seeds/*.rb>
# Pathname.glob{ |path|  } # pathをループさせる。
# ループの中で,ファイル毎にタスクを登録する。
# [るりま: Pathname#join](https://docs.ruby-lang.org/ja/latest/method/Pathname/i/join.html)
# [るりま: Pathname.glob](https://docs.ruby-lang.org/ja/latest/method/Pathname/s/glob.html)
# [るりま: Kernel#desc](https://docs.ruby-lang.org/ja/latest/method/Kernel/i/desc.html)
# [るりま: Kernel#task](https://docs.ruby-lang.org/ja/latest/method/Kernel/i/task.html)
# [Rake:  Kernel.task](https://ruby.github.io/rake/Rake/DSL.html#method-i-task)
# [Rake:  Kernel.desc](https://ruby.github.io/rake/Rake/DSL.html#method-i-desc)
