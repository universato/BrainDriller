# frozen_string_literal: true

require 'application_system_test_case'

class DrillsTest < ApplicationSystemTestCase
  include Warden::Test::Helpers
  def setup
  end

  def login_as_basic_member
    login_as(users(:smith), scope: :user)
  end

  test "create drill" do
    login_as_basic_member

    visit '/drills/new'
    fill_in "drill-title", with: "Drill Title"
    fill_in "drill-guide", with: "Drill Guide"
    click_button "問題を追加していく"
  end

  test "drills" do
    login_as_basic_member

    visit 'drills'
  end
end
