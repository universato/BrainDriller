# frozen_string_literal: true
class AddNamesToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :nickname, :string
    add_column :users, :login_name, :string
    add_index :users, :login_name
  end
end
