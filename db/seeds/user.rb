class UserCreator
  def self.insert_all
    user_creator = self.new
    yield(user_creator)
    user_creator.insert_all
  end

  def initialize
    @users = []
    @encrypted_password = Devise::Encryptor.digest(User, 'foobar')
  end

  def add(name, admin: false)
    time = Time.current
    user = {
      login_name: name,
      nickname: name,
      email: "#{name}@example.com",
      admin: admin,
      encrypted_password: @encrypted_password,
      confirmed_at: time,
      created_at: time,
      updated_at: time,
    }
    @users << user
  end

  def insert_all
    User.insert_all!(@users)
  end
end

UserCreator.insert_all do |user_creator|
  user_creator.add("uni", admin: true)
  user_creator.add("ruby")
  user_creator.add("normal")
end

# Rails・seedファイルを分割して管理する - Qiita https://qiita.com/masaki7555/items/d65f56958020cbca5ee0
